# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    name_en { Faker::Game.title }
    subsite { association(:subsite, strategy: :create) }
    place { association(:place, strategy: :create) }
    start_at { Faker::Time.backward(days: 4000, period: :evening) }
    description_en { Faker::Lorem.paragraphs(number: 1).join }
    notes_en { Faker::Lorem.paragraphs(number: 4).join }
    published { true }
    image { File.new(File.join(::Rails.root.to_s, 'spec/fixtures/images/event.jpg')) }
    facebook_link { Faker::Internet.url(host: 'facebook.com') }
    cost { [nil, nil, nil, nil, nil, nil, nil, 5, 3, nil, nil, 10].sample }
    trait :with_project do
      association :project
    end
    trait :with_residency do
      association :residency
    end
    trait :with_festival do
      association :festival
    end
    after(:build) do |f|
      f.end_at = f.start_at + 3.hours
    end
  end
end
