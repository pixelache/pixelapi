# frozen_string_literal: true

FactoryBot.define do
  factory :place do
    name_en { Faker::University.name }
    address1 { Faker::Address.street_address }
    address2 { [Faker::Address.street_address, nil, nil, nil].sample }
    city { Faker::Address.city }
    postcode { Faker::Address.postcode }
    country { Faker::Address.country_name_to_code }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end
