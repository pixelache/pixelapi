require 'rails_helper'

RSpec.describe Node, type: :model do

  before(:all) do
    Faker::UniqueGenerator.clear
  end

  context 'with validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:website) }
  end

  it 'should have a valid factory' do
    expect(FactoryBot.build(:node).save).to be true
  end

  it 'should get logo dimensions' do
    node = FactoryBot.create(:node)
    expect(node.logo_width).to be > 0
    expect(node.logo_height).to be > 0
    expect(node.logo_size).to be > 0
    expect(node.logo_content_type).not_to be nil
  end
end