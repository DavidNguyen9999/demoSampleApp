require "rails_helper"

RSpec.describe Comment, type: :model do
    let(:user) { create(:user) }
    let(:micropost) { create(:micropost, content: 'MyPost', user_id: user.id )}
    let!(:comment) { create(:comment, content: 'first comment', micropost_id: micropost.id, user_id: user.id) }
    context "factory" do
        it "has a valid factory" do
            expect(comment).to be_valid
        end
    end
    context "associations" do
        it { is_expected.to belong_to :user }
        it { is_expected.to belong_to :micropost }
    end
    context "validates" do
        it { is_expected.to validate_presence_of :content }
        it { is_expected.to validate_length_of(:content).is_at_most(140) }
        it { is_expected.to validate_presence_of :user }
    end
end