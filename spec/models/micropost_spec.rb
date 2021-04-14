require "rails_helper"

RSpec.describe Micropost, type: :model do
    let(:user) { create(:user) }
    let!(:micropost) { create(:micropost, content: 'MyPost', user_id: user.id )}
    context "factory" do
        it "has a valid factory" do
            expect(micropost).to be_valid
        end
    end
    context "associations" do
        it { is_expected.to belong_to :user }
        it { is_expected.to have_many(:comments).dependent(:destroy) }
        it { is_expected.to have_one_attached :image}
    end
    context "validates" do
        it { is_expected.to validate_presence_of :content }
        it { is_expected.to validate_presence_of :user_id }
        it { is_expected.to validate_length_of(:content).is_at_most(140) }
    end
end
