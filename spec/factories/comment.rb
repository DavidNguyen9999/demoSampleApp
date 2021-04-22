FactoryBot.define do
    factory :comment do
      content {'Anythings'} 
      user
      micropost
    end
  end
  