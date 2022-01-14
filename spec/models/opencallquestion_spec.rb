# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Opencallquestion, type: :model do
  before(:all) do
    Faker::UniqueGenerator.clear
  end

  context 'with validations' do
    it { is_expected.to validate_presence_of(:question_type) }
    it { is_expected.to validate_presence_of(:opencall) }
  end

  it 'should have a valid factory' do
    expect(FactoryBot.build(:opencallquestion).save).to be true
  end
end
