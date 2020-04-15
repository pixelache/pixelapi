require 'rails_helper'

RSpec.describe Opencall, type: :model do

  before(:all) do
    Faker::UniqueGenerator.clear
  end

  context 'with validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:subsite) }
  end

  it 'should have a valid factory' do
    expect(FactoryBot.build(:opencall).save).to be true
  end
end