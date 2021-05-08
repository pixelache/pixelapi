# frozen_string_literal: true

FactoryBot.define do
  factory :festivaltheme do
    name_en { Faker::Game.title }
    association :festival
    image { nil }
  end
end