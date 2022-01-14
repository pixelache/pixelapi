class Membership < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :year
  
  scope :paid, -> () { where(paid: true) }
  scope :by_year, ->(year) { where(year: year) }
end
