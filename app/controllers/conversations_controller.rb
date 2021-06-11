# frozen_string_literal: true

# Class ConversationsController
class ConversationsController < ApplicationController
  def create
    set_conversation
    @recipient = User.find_by(id: conversation_param[:recipient_id])
  end

  private

  def set_conversation
    @conversation = Conversation.find_by(sender_id: conversation_param[:recipient_id],
                                         recipient_id: current_user.id) ||
                    Conversation.find_by(recipient_id: conversation_param[:recipient_id],
                                         sender_id: current_user.id)
    return unless @conversation.nil?

    @conversation = Conversation.create(sender_id: current_user.id,
                                        recipient_id: conversation_param[:recipient_id])
  end

  def conversation_param
    params.permit(:recipient_id)
  end
end
