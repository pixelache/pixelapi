class FestivalthemeRelation < ApplicationRecord
  belongs_to :festivaltheme
  belongs_to :relation, polymorphic: true
end