require 'rails_helper'

RSpec.describe Festivaltheme, type: :model do

  before(:all) do
    Faker::UniqueGenerator.clear
  end

  context 'with validations' do
    it { is_expected.to validate_presence_of(:festival) }
  end

  it 'should have a valid factory' do
    expect(FactoryBot.build(:festivaltheme).save).to be true
  end
end