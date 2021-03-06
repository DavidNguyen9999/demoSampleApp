require 'rails_helper'

RSpec.describe Conversation, type: :model do
  let(:user) { create(:user) }
  let(:another_user) { create(:Another_user) }
  let(:conversation) do
    Conversation.new(sender_id: user.id,
                     recipient_id: another_user.id)
  end
  let(:reverse_conversation) do
    Conversation.new(sender_id: another_user.id,
                     recipient_id: user.id)
  end

  it 'should valid' do
    expect(conversation.valid?).to eq(true)
  end
  context 'when saved dup_conversation' do
    let!(:dup_conversation_saved) do
      Conversation.create(sender_id: user.id,
                          recipient_id: another_user.id)
    end

    it 'should not valid with existed member with reverse' do
      expect(reverse_conversation.save).to eq(false)
      expect(reverse_conversation.errors.messages[:discount]).to include('unique_revert_conversation')
    end
  end
end
