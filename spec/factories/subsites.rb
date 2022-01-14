# frozen_string_literal: true

FactoryBot.define do
  factory :subsite do
    name { Faker::Internet.domain_word }
    description { Faker::ChuckNorris.fact }
    subdomain { Faker::Internet.domain_word }
  end
end
