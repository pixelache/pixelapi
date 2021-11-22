# frozen_string_literal: true

FactoryBot.define do
  factory :festival do
    name { Faker::Sports::Football.competition }
    start_at { Faker::Date.backward(days: 4000) }
    website { Faker::Internet.url(host: 'pixelache.ac') }
    association :node
    subtitle { Faker::Hipster.sentence }
    background_colour { Faker::Color.hex_color}
    primary_colour { Faker::Color.hex_color }
    image { File.new(File.join(::Rails.root.to_s, 'spec/fixtures/images/festival.png')) }
    published { true }
    festivalbackdrop { File.new(File.join(::Rails.root.to_s, 'spec/fixtures/images/background.jpg')) }
    festival_location { Faker::Address.community }
    tertiary_colour { Faker::Color.hex_color }
    overview_text_en { Faker::Lorem.paragraphs(number: 4).join }
    trait :with_project do
      association :with_project
    end
    trait :with_user_account do
      association :user
    end
    trait :with_subsite do
      association :subsite
    end
    after(:build) do |res|
      res.end_at = res.start_at + 1.week
    end
  end
end