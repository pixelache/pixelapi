class Opencall < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name , :use => [ :slugged, :finders ] # :history]
  translates :description, fallbacks_for_empty_translations: true
  globalize_accessors locales: I18n.available_locales, attributes: [:description]

  # associations
  belongs_to :subsite
  has_one :page
  has_many :opencallquestions, dependent: :destroy
  has_many :opencallsubmissions, dependent: :destroy
  
  accepts_nested_attributes_for :opencallquestions

  # validations
  validates :name, presence: true
  validates :subsite, presence: true
  class Translation
    validates :description, presence: true
  end
  
end
