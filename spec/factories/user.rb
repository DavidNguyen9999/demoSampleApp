FactoryBot.define do
    factory :user, class: User do
      name {Faker::Name.name}
      email {Faker::Internet.email}
      password {'password'}
      password_confirmation { 'password' }
      confirmed_at { Date.today }
      after(:create) {|user| user.add_role(:admin)}
    end

    factory :Another_user, class: User do
      name {Faker::Name.name}
      email {Faker::Internet.email}
      password {'password2'}
      password_confirmation { 'password2' }
      confirmed_at { Date.today }
    end

    factory :super_admin, class: User do
      name {Faker::Name.name}
      email {Faker::Internet.email}
      password {'password'}
      password_confirmation { 'password' }
      confirmed_at { Time.now }
      after(:create) {|super_admin| super_admin.add_role(:super_admin)}
    end
  end
  