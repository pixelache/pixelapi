# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Place, type: :model do
  before(:all) do
    Faker::UniqueGenerator.clear
  end

  context 'with validations' do
    it { is_expected.to validate_presence_of(:address1) }
    it { is_expected.to validate_presence_of(:country) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_length_of(:country).is_at_least(2).is_at_most(2) }
  end

  it 'should have a valid factory' do
    expect(FactoryBot.build(:place).save).to be true
  end
end
