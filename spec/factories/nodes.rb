# frozen_string_literal: true

FactoryBot.define do
  factory :node do
    name { Faker::University.name }
    description_en { Faker::TvShows::Simpsons.quote }
    website { Faker::Internet.url }
    city { Faker::Address.city }
    country { Faker::Address.country_name_to_code }
    logo { File.new(File.join(::Rails.root.to_s, 'spec/fixtures/images/logo.jpg')) }
  end
end
