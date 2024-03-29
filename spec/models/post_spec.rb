# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  before(:all) do
    Faker::UniqueGenerator.clear
  end

  context 'with validations' do
    it { is_expected.to validate_presence_of(:subsite) }
    it { is_expected.to validate_presence_of(:creator) }
  end

  it 'should have a valid factory' do
    expect(FactoryBot.build(:post).save).to be true
  end
end
