require 'rails_helper'

RSpec.describe Contributor, type: :model do
  
  before(:all) do
    Faker::UniqueGenerator.clear
  end

  context 'with validations' do
    it { is_expected.to validate_presence_of(:alphabetical_name) }
    it { is_expected.to validate_presence_of(:name) }
  end

  context 'other tests' do
    it 'should have a valid factory' do
      expect(FactoryBot.build(:contributor).save).to be true
    end

    it 'should be relatable to festivals' do
      c = FactoryBot.create(:contributor)
      fs = FactoryBot.create_list(:festival, 2)
      c.festivals << fs
      expect(c.save).to be true
      expect(c.festivals.count).to eq 2
    end
  end
end
