# frozen_string_literal: true

# Class Conversation
class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
  belongs_to :chatable, polymorphic: true, optional: true

  scope :find_messenger, lambda { |sender_id, recipient_id|
    where(sender_id: sender_id, recipient_id: recipient_id)
      .or(where(sender_id: recipient_id, recipient_id: sender_id))
  }

  validate :unique_revert_conversation

  def unique_revert_conversation
    return unless Conversation.where(sender_id: recipient_id, recipient_id: sender_id).any?

    errors.add(:discount, 'unique_revert_conversation')
  end
end
