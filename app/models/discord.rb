# frozen_string_literal: true

# Class Discord
class Discord < ApplicationRecord
  has_many :conversations, as: :chatable
  belongs_to :user
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'

  validates :user_id, presence: true
end
