require 'rails_helper'

RSpec.describe NotificationsChannel, type: :channel do
  let!(:user) { create(:user) }
  let(:comment) { user.comments.create(content: 'Lorem ipsum') }
  context 'when user is loged in' do
    describe '#connect' do
      it "successfully subscribes" do
        stub_connection current_user: user
        subscribe
        expect(subscription).to be_confirmed
      end
    end
  end
  context 'when user is not loged in' do
    describe '#connect fail' do
      it "not subscribes" do
        stub_connection current_user: nil
        expect { subscribe }
        .not_to change(Comment, :count)
      end
    end
  end
end
