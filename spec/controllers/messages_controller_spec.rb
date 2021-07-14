require 'rails_helper'

describe MessagesController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:Another_user) }
  let!(:conversation) do
    Conversation.create(sender_id: user.id,
                        recipient_id: another_user.id)
  end
  let!(:message) { user.messages.create(conversation_id: conversation.id, content: 'test') }

  context 'when user is logged in' do
    before(:each) do
      sign_in user
    end
    it 'should success create new message' do
      expect do
        post :create, xhr: true, params: { message:{ content: 'test content', recipient_id: another_user.id,
                                           conversation_id: conversation.id}}
      end
        .to change(Message, :count).by(1)
      expect(Message.last.content).to eq('test content')
    end

    it 'should not create new message with invalid content' do
      expect do
        post :create, xhr: true, params: { message:{ content: '', recipient_id: another_user.id, conversation_id: conversation.id }}
      end
        .to change(Message, :count).by(0)
      expect(assigns(:error))
    end
  end
end
