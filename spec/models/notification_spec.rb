require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:user) { create(:user) }
  let(:another_user) { create(:Another_user) }
  let(:micropost) { create(:micropost, content: 'MyPost', user_id: user.id )}
  let!(:comment) { create(:comment, content: 'first comment', micropost_id: micropost.id, user_id: another_user.id) }
  let!(:notification) { comment.notifications.new(user_id: micropost.user_id, notified_by_id: another_user.id) }
  context "factory" do
      it "has a valid factory" do
          expect(notification).to be_valid
      end
  end
  context "associations" do
      it { is_expected.to belong_to :user }
      it { is_expected.to belong_to :notificationable }
  end
end
