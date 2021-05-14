require 'rails_helper'

RSpec.describe NotificationBroadcastJob, type: :job do
  let(:user) { create(:user) }
  let(:another_user) { create(:Another_user) }
  let(:micropost) { create(:micropost, content: 'MyPost', user_id: user.id )}
  let!(:comment) { create(:comment, content: 'first comment', micropost_id: micropost.id, user_id: another_user.id) }
  let!(:notification) { comment.notifications.create(user_id: micropost.user_id, notified_by_id: another_user.id, event:"New Comment",created_at: Time.now ) }
  describe "#perform_now" do
    it 'should success set NotificationBroadcastJob is enqueued_job ' do
      ActiveJob::Base.queue_adapter = :test
      expect{
      NotificationBroadcastJob.perform_later(notification, notification.user_id)
      }.to have_enqueued_job
    end
  end
end
