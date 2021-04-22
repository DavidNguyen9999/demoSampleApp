require "rails_helper"

RSpec.describe User, type: :model do
    let!(:user) { create(:user) }
    context "associations" do
        it { is_expected.to have_many(:microposts).dependent(:destroy) }
        it { is_expected.to have_many(:comments).dependent(:destroy) }
    end
    context "test devise" do
        before { create(:user) }
        it { is_expected.to validate_presence_of(:email) }
        it { should have_db_column(:id) }
        it { should have_db_column(:email) }
        it { should have_db_column(:encrypted_password) }
        it { should have_db_column(:confirmation_token) }
        it { should have_db_column(:confirmed_at) }
        it { should have_db_column(:confirmation_sent_at) }
        it 'is databse authenticable' do
            user = User.create(
                email: 'test@example.com', 
            password: '123456',
            password_confirmation: '123456'
            )
            expect(user.valid_password?('123456')).to be_truthy
        end
    end
end
