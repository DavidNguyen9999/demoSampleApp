require 'rails_helper'

describe ExportCsvService do
  let(:user) { create(:user) }
  let(:another_user) { create(:Another_user) }
  let!(:micropost) { user.microposts.create(content: 'Lorem ipsum') }
  let(:micropost_csv) do
    (ExportCsvService.new user)
  end
  let(:following_csv) do
    (ExportCsvService.new user)
  end
  let(:followers_csv) do
    (ExportCsvService.new another_user)
  end
  
  before(:each) do
    user.follow(another_user)
  end
  
  it 'should include micropost content' do
    expect(micropost_csv.microposts).to include('Lorem ipsum')
  end
  
  it 'should include following user in csv file' do
    expect(following_csv.following).to include(another_user.name)
  end
  
  it 'should include followed user in csv file' do
    expect(followers_csv.followed).to include(user.name)
  end
  
  context 'with old created (>1.month)' do
    before(:each) do
      Relationship.update_all(created_at: Time.now - 2.month)
      Micropost.update_all(created_at: Time.now - 2.month)
    end
  
    it 'should not include micropost in csv file' do
      expect(micropost_csv.microposts).to eq("Post,Date\n")
    end
  
    it 'should not include following in csv file' do
      expect(following_csv.following).to eq("Full Name,Date\n")
    end
  
    it 'should not include follower in csv file' do
      expect(followers_csv.followed).to eq("Full Name,Date\n")
    end
  end
end
