# frozen_string_literal: true

# Class Comment
class Comment < ApplicationRecord
  acts_as_votable
  acts_as_tree order: 'created_at ASC', dependent: :delete_all
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :childrens, class_name: 'Comment', foreign_key: 'parent_id'
  belongs_to :user
  belongs_to :micropost
  has_many :notifications, dependent: :destroy, as: :notificationable

  validates :user, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  scope :new_comment, -> { where(created_at: (Time.now - 1.day)..Time.now) }
end
