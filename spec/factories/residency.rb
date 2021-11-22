# frozen_string_literal: true

FactoryBot.define do
  factory :residency do
    name { Faker::Name.name  }
    start_at { Faker::Date.backward(days: 4000) }
    country { Faker::Address.country_name_to_code }

    description_en { Faker::Lorem.paragraphs(number: 2).join }
    is_micro { [false, false, false, false, false, false, true, true].sample }
    photo { File.new(File.join(::Rails.root.to_s, 'spec/fixtures/images/artist.jpg')) }

    trait :with_project do
      association :with_project
    end
    trait :with_user_account do
      association :user
    end
    after(:build) do |res|
      res.end_at = res.start_at + 2.weeks
    end
  end
end