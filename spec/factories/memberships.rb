# frozen_string_literal: true

FactoryBot.define do
  factory :membership do
    user { association(:user) }
    year { Time.now.year - 2 }
    paid { true }
    hallitus { [true, false, false, false].sample }
    hallitus_alternate { false }
    notes { nil }
  end
end
