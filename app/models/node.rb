class Node < ActiveRecord::Base
  translates :description
  globalize_accessors locales: [:en, :fi], attributes: [:description]
  mount_uploader :logo, ImageUploader
  extend FriendlyId
  friendly_id :name, :use => :finders
  
  # associations
  has_and_belongs_to_many :subsites
  accepts_nested_attributes_for :translations, :reject_if => proc {|x| x['description'].blank? }

  # validations
  validates :name, presence: true, uniqueness: true
  validates :website, presence: true, uniqueness: true
  
  # hooks + callbacks
  before_save :update_image_attributes

  private

  def update_image_attributes
    if logo.present? && logo_changed?
      if logo.file.exists?
        self.logo_content_type = logo.file.content_type
        self.logo_size = logo.file.size
        self.logo_width, self.logo_height = `identify -format "%wx%h" #{logo.file.path}`.split(/x/)
      end
    end
  end
  
end
