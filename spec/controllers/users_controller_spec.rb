require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user_admin) {create(:user)}
  let!(:user_b) {create(:Another_user)}
  let!(:micropost_a) {
    user_admin.microposts.create(FactoryBot.attributes_for(:micropost))
  }
  let(:valid_attributes) {
    FactoryBot.attributes_for(:user)
  }
  describe "User Action" do
    context "GET #new" do
      before do
        sign_in user_admin
        get :new
      end
      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :new }
    end
    context "GET #show" do
      before do
        sign_in user_admin
        get :show, params: { id: micropost_a.id}
      end
      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :show }
    end
    context "DELETE #destroy" do
      context "When user is Admin" do
        before do
          sign_in user_admin
        end
        it "should success del user" do
          expect do
            delete :destroy, params: { id: user_b.id }
          end.to change(User, :count).by eq(-1)
          expect(response).to redirect_to(users_url)
        end
      end
      context "When user is not Admin" do
        before do
          sign_in user_b
        end
        it "should not delete user" do
          expect do
            delete :destroy, params: { id: user_b.id }
          end.to change(User, :count).by eq(0)
        end
      end
    end
  end
end