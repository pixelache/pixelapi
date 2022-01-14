# frozen_string_literal: true

FactoryBot.define do
  factory :opencallquestion do
    association :opencall
    question_type { [1, 2, 4].sample }
    sort_order { 1 }
    character_limit { nil }
    is_required { false }
    question_text_en { Faker::Lorem.sentence[0] }
  end
end
