require 'rails_helper'

RSpec.describe MessageBroadcastJob, type: :job do
  include ActiveJob::TestHelper
  
  let(:user) { create(:user) }
  let(:another_user) { create(:Another_user) }
  let!(:conversation) do
    Conversation.create(sender_id: user.id,
                        recipient_id: another_user.id)
  end
  let!(:message) { user.messages.create(content: 'test string', conversation_id: conversation.id) }

  context 'render messages' do
    it 'should return render messages' do
      expect(MessageBroadcastJob.new.send(:render_message, message, another_user.id)).to include('test string')
    end
  end
end
