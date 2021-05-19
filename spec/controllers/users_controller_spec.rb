require 'rails_helper'
require "cancan/matchers"

RSpec.describe UsersController, type: :controller do
  let!(:super_admin) {create(:super_admin)}
  let!(:admin) {create(:user)}
  let!(:user_b) {create(:Another_user)}
  let!(:micropost_a) {
    admin.microposts.create(FactoryBot.attributes_for(:micropost))
  }
  let(:valid_attributes) {
    FactoryBot.attributes_for(:user)
  }
  describe "User Action" do
    context "GET #new" do
      before do
        get :new
      end
      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :new }
    end
    context "GET #show" do
      before do
        sign_in admin
        get :show, params: { id: micropost_a.id}
      end
      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :show }
    end
    context "DELETE #destroy" do
      context "When user is Super_Admin" do
        before do
          sign_in super_admin
        end
        it "should success del Admin" do
          expect do
            delete :destroy, params: { id: admin.id }
          end.to change(User, :count).by eq(-1)
          expect(response).to redirect_to(users_url)
        end
      end
      context "When user is Admin" do
        before do
          sign_in admin
        end
        it "should success del User" do
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
        it "should not alow to delete user" do
          ability = Ability.new(user_b)
          expect(ability).to_not be_able_to(:destroy, User.new)
        end
      end
    end
  end
end
