# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    email { Faker::Internet.email }
    password { 'test_password' }
    username { Faker::Internet.username(specifier: 5..18) }
    website { Faker::Internet.url }
    bio { Faker::Quote.most_interesting_man_in_the_world }

    trait :twitter do
      twitter_name { Faker::Internet.username(specifier: 5..8) }
    end
    trait :avatar do
      avatar { File.new(File.join(::Rails.root.to_s, 'spec/fixtures/images/gaddis.jpg')) }
    end
    trait :confirmed do
      after(:create, &:confirm)
    end
    trait :member do
      after(:create) do |user|
        user.add_role(:member)
        user.confirm
      end
    end
    trait :admin do
      after(:create) do |user|
        user.add_role(:goddess)
        user.confirm
      end
    end
  end
end
