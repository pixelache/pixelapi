class ContributorRelation < ApplicationRecord
  belongs_to :contributor
  belongs_to :relation, polymorphic: true
  validates :contributor, presence: true
end
