# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Membership, type: :model do
  before(:all) do
    Faker::UniqueGenerator.clear
  end

  context 'with validations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to validate_presence_of(:year) }
  end

  it 'should have a valid factory' do
    expect(build(:membership).save).to be true
  end
end
