# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Opencallsubmission, type: :model do
  before(:all) do
    Faker::UniqueGenerator.clear
  end

  context 'with validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:phone) }
    it { is_expected.to validate_presence_of(:opencall) }
  end

  it 'should have a valid factory' do
    expect(FactoryBot.build(:opencallsubmission).save).to be true
  end

  it 'should not be allowed after open call deadline has passed' do
    a = FactoryBot.create(:opencall, closing_date: 1.hour.ago)
    expect(FactoryBot.build(:opencallsubmission, opencall: a).save).to be false
  end
end
