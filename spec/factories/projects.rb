# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    name { Faker::Game.title }
    description_en { Faker::Lorem.paragraphs(number: 3).join }
    short_description_en { Faker::Lorem.paragraphs(number: 1).join }
    hidden { false }
  end
end
