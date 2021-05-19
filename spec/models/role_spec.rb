require 'rails_helper'

RSpec.describe Role, type: :model do
  describe "roles" do

    before(:each) do
      @user = FactoryBot.create(:user)
    end
  
    it "should not approve incorrect roles" do
      @user.has_role?(:super_admin).should be_falsey
    end
  
    it "should approve correct roles" do
      @user.has_role?(:admin).should be_truthy
    end
  
  end
  
end
