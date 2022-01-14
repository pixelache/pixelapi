# frozen_string_literal: true

FactoryBot.define do
  factory :opencallanswer do
    association :opencallquestion
    association :opencallsubmission
    answer { Faker::Lorem.paragraphs(number: 2).join }
    attachment { nil }
    trait :with_attachment do
      attachment { File.new(File.join(::Rails.root.to_s, 'spec/fixtures/images/gaddis.jpg')) }
    end
  end
end
