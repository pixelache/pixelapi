require 'rails_helper'

RSpec.describe ContributorRelation, type: :model do
  context 'with validations' do
    it { is_expected.to validate_presence_of(:contributor) }
  end
end
