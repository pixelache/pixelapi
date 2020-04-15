require 'rails_helper'

RSpec.describe Festival, type: :model do

  before(:all) do
    Faker::UniqueGenerator.clear
  end

  context 'with validations' do
    it { is_expected.to validate_presence_of(:node) }
    it { is_expected.to validate_presence_of(:name) }
  end

  it 'should have a valid factory' do
    expect(FactoryBot.build(:festival).save).to be true
  end
end