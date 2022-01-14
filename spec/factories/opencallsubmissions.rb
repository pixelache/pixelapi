# frozen_string_literal: true

FactoryBot.define do
  factory :opencallsubmission do
    association :opencall
    name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    email { Faker::Internet.email   }
    phone { Faker::PhoneNumber.phone_number_with_country_code.gsub(/[^+]\D+/, '') }
  end
end
