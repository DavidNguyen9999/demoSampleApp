require 'rails_helper'

describe ExportCsvController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:Another_user) }
  let!(:micropost) { user.microposts.create(content: 'Lorem ipsum') }
  let(:micropost_csv) do
    ExportCsvService.new Micropost.last_month.by_user(user), Micropost::CSV_ATTRIBUTES
  end
  let(:following_csv) do
    ExportCsvService.new user.following_last_month, User::CSV_ATTRIBUTES
  end
  let(:followers_csv) do
    ExportCsvService.new user.followed_last_month, User::CSV_ATTRIBUTES
  end
  context 'when user is logged in' do
    let(:hash) do 
      { 
        :micropost_csv => micropost_csv,
        :following_csv => following_csv,
        :followers_csv => followers_csv
      }
    end
    before(:each) do
      sign_in user
      user.follow(another_user)
      another_user.follow(user)
    end

    it 'should hash to zip' do
      @list_file = []
      Zip::OutputStream.write_buffer do |f|
        hash.each do 
          @list_file << f
        end
      end
      expect(@list_file.count).to eq(hash.count)
    end
  end
end