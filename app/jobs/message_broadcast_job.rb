class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message, recipient, conversation_id, current_user, request)
    ActionCable.server.broadcast "user_conversation_#{recipient.id}", { conversation_id: conversation_id,
                                                                       sender_id: current_user.id,
                                                                       conversation: render_conversation(recipient, conversation_id,  request),
                                                                       messages: render_message(message, recipient) }
  end

  private

  def render_message(message, recipient)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message,
                                                                              current_user: recipient })
  end

  def render_conversation (recipient, conversation_id,  request)
    conversation = Conversation.find_by(id: conversation_id)
    warden = request.env["warden"]
    ApplicationController.renderer.instance_variable_set(:@env, {
      "HTTP_HOST"=>"localhost:3000", 
      "HTTPS"=>"off", 
      "REQUEST_METHOD"=>"GET", 
      "SCRIPT_NAME"=>"",   
      "warden" => warden
    })
    ApplicationController.render(partial: "conversations/conversation_box",
                                          locals: { conversation: conversation,
                                                    recipient: recipient })
  end
end
