# frozen_string_literal: true

# Class Relationship
class Relationship < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  scope :last_month, -> { where(created_at: (Time.now - 1.month)..Time.now) }
  scope :find_relationship, ->(follower_id, followed_id) { where(follower_id: follower_id, followed_id: followed_id) }
end
