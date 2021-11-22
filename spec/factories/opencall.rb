# frozen_string_literal: true

FactoryBot.define do
  factory :opencall do
    association :subsite
    published { [true, true, true, true, true, true, false].sample }
    is_open { true }
    submitted_text { Faker::Lorem.paragraphs(number: 1).join }
    description_en { Faker::Lorem.paragraphs(number: 3).join }
    name {Faker::Game.title }
    closing_date { Faker::Date.forward(days: 40) }

    trait :with_page do
      association :page
    end


  end
end