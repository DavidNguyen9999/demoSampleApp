# frozen_string_literal: true

# Class Micropost
class Micropost < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png], message: 'must be a valid image format' },
                    size: { less_than: 5.megabytes, message: 'should be less than 5MB' }
  CSV_ATTRIBUTES = %w[content created_at].freeze
  scope :last_month, -> { where(created_at: (Time.now - 1.month)..Time.now) }
  scope :by_user, ->(user) { where(user_id: user.id) }
  scope :new_posts, -> { where(created_at: (Time.now - 1.day)..Time.now) }

  # Returns a resized image for display.
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end
