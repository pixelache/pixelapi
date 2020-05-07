require 'rails_helper'

RSpec.describe Opencallanswer, type: :model do

  before(:all) do
    Faker::UniqueGenerator.clear
  end

  context 'with validations' do
    it { is_expected.to validate_presence_of(:opencallquestion) }
    it { is_expected.to validate_presence_of(:opencallsubmission) }
  end

  it 'should have a valid factory' do
    expect(FactoryBot.build(:opencallanswer).save).to be true
  end

  it 'should not allow saving an answer without an answer' do
    q = FactoryBot.create(:opencallquestion, question_type: 2)
    expect(FactoryBot.build(:opencallanswer, opencallquestion: q, answer: nil).save).to be false
  end

  it 'should not allow saving without attachment for attachment questions' do
    q = FactoryBot.create(:opencallquestion, question_type: 3)
    expect(FactoryBot.build(:opencallanswer, opencallquestion: q, attachment: nil).save).to be false
  end
end