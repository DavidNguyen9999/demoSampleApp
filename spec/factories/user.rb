FactoryBot.define do
    factory :user, class: User do
      name {Faker::Name.name}
      email {Faker::Internet.email}
      password {'password'}
      password_confirmation { 'password' }
      confirmed_at { Date.today }
      admin {:true}
    end
    factory :Another_user, class: User do
      name {Faker::Name.name}
      email {Faker::Internet.email}
      password {'password2'}
      password_confirmation { 'password2' }
      confirmed_at { Date.today }
    end
  end
  