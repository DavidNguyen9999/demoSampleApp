# frozen_string_literal: true

# Class MessagesController
class MessagesController < ApplicationController
  def create
    @message = current_user.messages.build(message_params)
    @conversation = Conversation.find_by(id: message_params[:conversation_id])
    @recipient = User.find_by(id: message_params[:recipient_id])
    broadcast_perform
  end

  private

  def broadcast_perform
    if @message.save
      MessageBroadcastJob.perform_now(@message,
                                      @recipient,
                                      message_params[:conversation_id],
                                      current_user, request)
    else
      @error = @message.errors.messages
    end
  end

  def message_params
    params.require(:message).permit(:conversation_id, :content, :recipient_id)
  end
end
