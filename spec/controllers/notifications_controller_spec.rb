require 'rails_helper'

describe NotificationsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:Another_user) }
  let(:micropost) { create(:micropost, content: 'MyPost', user_id: user.id )}
  let!(:comment) { create(:comment, content: 'first comment', micropost_id: micropost.id, user_id: another_user.id) }
  let!(:notification) { comment.notifications.create(user_id: micropost.user_id, seen: false, notified_by_id: another_user.id, event:"New Comment",created_at: Time.now ) }
  context 'when user is logged in' do
    before do
      sign_in user
    end
    it 'should change notification.seen' do
      expect do
        put :update, xhr: true, params: { id: notification.id }
      end
        .to change { notification.reload.seen }.from(false).to(true)
      expect(response).to render_template('notifications/update')
    end

    it 'should change notification.seen' do
      expect do
        get :show, params: { id: notification.id }
      end
        .to change { notification.reload.seen }.from(false).to(true)
      expect(response).to redirect_to(user)
    end
  end

  context 'when not logged in' do
    it 'should not change notification' do
      expect do
        get :show, params: { id: notification.id }
      end
      expect(response).to_not render_template('notifications/show')
    end

    it 'should not change notification' do
      expect do
        put :update, xhr: true, params: { id: notification.id }
      end
      expect(response).to_not render_template('notifications/update')
    end
  end

  context 'when logged in with another user' do
    before do
      sign_in another_user
    end

    it 'should not change notification' do
      expect do
        get :show, params: { id: notification.id }
      end
      expect(response).to_not render_template('notifications/show')
    end

    it 'should not change notification' do
      expect do
        put :update, xhr: true, params: { id: notification.id }
      end
      expect(response).to_not render_template('notifications/update')
    end
  end
end
