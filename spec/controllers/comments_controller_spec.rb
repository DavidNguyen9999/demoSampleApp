require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  #Create user A
  let(:user_a) {
    FactoryBot.create(:user)
  }
  #Create a post whose author is User A
  let(:micropost_a) {
    user_a.microposts.create(FactoryBot.attributes_for(:micropost))
  }
  let(:valid_attributes) {
    FactoryBot.attributes_for(:comment)
  }
  let!(:comment_saved) { user_a.comments.create(content: 'Lorem ipsum', micropost_id: micropost_a.id) }
  describe "Comment Action" do
    context 'when user is logged in' do
      before do 
        sign_in user_a
      end
      
      it 'should success create cmt' do
        expect do
          post :create, xhr: true, params: { comment: {user_id: user_a.id, micropost_id: micropost_a.id, content: 'a' }}
        end
          .to change(Comment, :count).by eq(1)
        expect(response).to render_template('comments/create')
      end
      it 'should success del cmt' do
        expect do
          delete :destroy, xhr: true, params: { id: comment_saved.id }
        end
          .to change(Comment, :count).by eq(-1)
        expect(response).to render_template('comments/destroy')
      end
      it 'should not success create new cmt with invalid content' do
        expect do
          post :create, xhr: true, params: { comment: {user_id: user_a.id, micropost_id: micropost_a.id, content: nil || 'a' *150 }}
        end.to change(Comment, :count).by(0)
      end
    end
    context 'when user is not logged in' do
      it 'should not show Form comment' do
        expect(response).to_not render_template('comments/create')
      end
      it 'should not show button delete' do
        expect(response).to_not render_template('comments/destroy')
      end
    end
    context 'when logged in not correct_user' do
      before do 
        user_b = create(:Another_user)
        sign_in user_b
      end
      it 'should not show button delete' do
        expect(response).to_not render_template('comments/destroy')
      end
    end
  end
end
