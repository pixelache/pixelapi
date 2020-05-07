class Opencallquestion < ActiveRecord::Base
  translates :question_text, :fallbacks_for_empty_translations => true
  globalize_accessors locales: I18n.available_locales, attributes: [:question_text]

  # associations
  belongs_to :opencall
  has_many :opencallanswers

  accepts_nested_attributes_for :translations, :reject_if => proc {|x| x['question_text'].blank? }

  # validations
  validates :opencall, presence: true
  validates :question_type, presence: true

  class Translation
    validates :question_text, presence: true
  end
  

  # question_type field
  #
  # 1 = free text
  # 2 = string 
  # 3 = file
  # 4 = url
  # 5 = yes/no boolean
end
