# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContributorRelation, type: :model do
  context 'with validations' do
    it { is_expected.to validate_presence_of(:contributor) }
    it { is_expected.to validate_presence_of(:relation_id) }
  end

  it 'cannot have a duplicate worksite relation' do
    contributor = FactoryBot.create(:contributor)
    project = FactoryBot.create(:project)
    cr = ContributorRelation.create(contributor: contributor, relation: project)
    cr2 = ContributorRelation.new(contributor: contributor, relation: project)
    expect(cr2.save).to be false
  end
end
