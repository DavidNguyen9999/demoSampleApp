# frozen_string_literal: true

# Class User
class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :timeoutable, :omniauthable
  acts_as_voter
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy
  scope :last_month, -> { where(created_at: (Time.now - 1.month)..Time.now) }

  CSV_ATTRIBUTES = %w[name created_at].freeze

  # Follows a user.
  def follow(other_user)
    following << other_user
  end

  # Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  def following_last_month
    following = Relationship.last_month.where(follower_id: id).pluck(:followed_id)
    User.where(id: following)
  end

  def followed_last_month
    follower = Relationship.last_month.where(followed_id: id).pluck(:follower_id)
    User.where(id: follower)
  end

  def self.skip_confirm_and_save(user)
    user.skip_confirmation!
    user.skip_confirmation_notification!
    user.save
  end

  def self.find_for_google_oauth2(access_token)
    data = access_token.info
    registered_user = User.where(email: data['email']).first

    return registered_user if registered_user

    user = User.where(provider: access_token[:provider], uid: access_token[:uid])
               .first_or_initialize(name: data['name'], provider: access_token[:provider],
                                    email: data['email'], uid: access_token[:uid],
                                    image: data['image'], password: Devise.friendly_token[0, 20])
    skip_confirm_and_save(user)
    user
  end

  def self.find_for_facebook_oauth(access_token)
    data = access_token.info
    registered_user = User.where(email: data['email']).first

    return registered_user if registered_user

    user = User.where(provider: access_token[:provider], uid: access_token[:uid])
               .first_or_initialize(name: data['name'], provider: access_token[:provider],
                                    email: data['email'], uid: access_token[:uid],
                                    image: data['image'], password: Devise.friendly_token[0, 20])
    skip_confirm_and_save(user)
    user
  end
end
