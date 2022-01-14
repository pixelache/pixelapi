# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subsite, type: :model do
  before(:all) do
    Faker::UniqueGenerator.clear
  end

  context 'with validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:subdomain) }
  end
end
