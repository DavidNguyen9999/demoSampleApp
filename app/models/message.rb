# frozen_string_literal: true

# Class Message
class Message < ApplicationRecord
  belongs_to :user
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
  belongs_to :conversation
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  validates :conversation_id, presence: true
end
