# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:username) }
  end

  it 'has a valid factory' do
    expect(FactoryBot.build(:user, password: 'rand23423om').save).to be true
  end

  it 'should be able to upload avatar' do
    user = FactoryBot.create(:user, :avatar)
    expect(user.avatar_url).not_to be nil
  end

end