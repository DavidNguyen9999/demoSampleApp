FactoryBot.define do
    factory :micropost do
      content { 'Text' }
      user
    end
  end