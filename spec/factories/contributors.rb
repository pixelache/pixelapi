# frozen_string_literal: true

FactoryBot.define do
  factory :contributor do
    name { Faker::Name.name }
    alphabetical_name { Faker::Name.name }
    website { Faker::Internet.url }
    bio { Faker::Lorem.paragraphs(number: 2).join }
    image { File.new(File.join(::Rails.root.to_s, 'spec/fixtures/images/artist.jpg')) }
    user { nil }
  end
end
