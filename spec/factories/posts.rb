# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    association :subsite
    published { [true, true, true, true, true, true, false].sample }
    association :creator, factory: :user
    title_en { Faker::Book.title }
    body_en { Faker::Lorem.paragraphs(number: 3).join }
    published_at { Faker::Date.backward(days: 4000) }
    trait :project do
      transient do
        project_id { nil }
      end
      after(:create) do |post, evaluator|
        post.project = evaluator.project
      end
    end

    trait :festival do
      transient do
        festival_id { nil }
      end
      after(:create) do |post, evaluator|
        post.festival = evaluator.project
      end
    end
  end
end
