require 'rails_helper'

RSpec.describe Event, type: :model do

  before(:all) do
    Faker::UniqueGenerator.clear
  end

  context 'with validations' do
    it { is_expected.to validate_presence_of(:name_en) }
  end

  it 'should have a valid factory' do
    expect(FactoryBot.build(:event).save).to be true
  end
end