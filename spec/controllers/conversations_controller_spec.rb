require 'rails_helper'

describe ConversationsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:Another_user) }

  context 'when user is logged in' do
    before(:each) do
      sign_in user
    end
    it 'should success create new Conversation' do
      expect do
        post :create, xhr: true, params: { recipient_id: another_user.id }
      end
        .to change(Conversation, :count).by(1)
      expect(Conversation.last.recipient_id).to eq(another_user.id)
      expect(Conversation.last.sender_id).to eq(user.id)
    end
  end
end
