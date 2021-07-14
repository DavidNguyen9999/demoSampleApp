require 'rails_helper'

RSpec.describe Message, type: :model do
  let!(:user) { create(:user) }
  let!(:another_user) { create(:Another_user) }
  let!(:conversation) do
    Conversation.create(sender_id: another_user.id,
                        recipient_id: user.id)
  end
  let(:message) { user.messages.build(content: 'test string', conversation_id: conversation.id, recipient_id: another_user.id) }

  it 'should valid' do
    expect(message.valid?).to eq(true)
  end

  it 'should not valid with nil conversation_id' do
    message.conversation_id = nil
    expect(message.valid?).to eq(false)
  end

  it 'should not valid with blank content' do
    message.content = ''
    expect(message.valid?).to eq(false)
  end
end
