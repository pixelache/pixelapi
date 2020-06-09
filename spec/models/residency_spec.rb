require 'rails_helper'

RSpec.describe Residency, type: :model do

  before(:all) do
    Faker::UniqueGenerator.clear
  end

  context 'with validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:start_at) }
  end

  it 'should have a valid factory' do
    expect(FactoryBot.build(:residency).save).to be true
  end

  it 'should get photo dimensions' do
    artist = FactoryBot.create(:residency)
    expect(artist.photo_width).to be > 0
    expect(artist.photo_height).to be > 0
    expect(artist.photo_size).to be > 0
    expect(artist.photo_content_type).not_to be nil
  end
end