class Residency < ActiveRecord::Base
  # features
  extend FriendlyId
  friendly_id :name, use: [:finders, :slugged]
  translates :description, fallbacks_for_empty_translations: true
  globalize_accessors locales: [:en, :fi], attributes: [:description]
  mount_uploader :photo, ImageUploader

  # associations
  belongs_to :project, optional: true
  belongs_to :user, optional: true
  has_many :posts
  has_many :events
  accepts_nested_attributes_for :translations, :reject_if => proc {|x| x['description'].blank? }

  # validations + callbacks
  validates_presence_of :start_at, :name
  validates :country, length: { minimum: 2, maximum: 2 }, allow_blank: true
  validate :country_or_override
  before_save :update_photo_attributes

  # scopes
  scope :micro, -> { where(is_micro: true) }
  scope :production, -> { where("is_micro is not true")}
  
  def country_or_override
    errors.add(:country, I18n.t('api.errors.residency.missing_country')) if country.blank? && country_override.blank?
  end

  def related_content
    out = []
    # out << project if project
    out << posts.published
    out << events.published
    out.unshift project if project
    out.flatten.compact.uniq
  end
  
  def body
    description
  end
  
  def feed_time
    start_at
  end
  
  private
  
  def update_photo_attributes
    if photo.present? && photo_changed?
      if photo.file.exists?
        self.photo_content_type = photo.file.content_type
        self.photo_size = photo.file.size
        self.photo_width, self.photo_height = `identify -format "%wx%h" #{photo.file.path}`.split(/x/)
      end
    end
  end

  def should_generate_new_friendly_id?
    name_changed?
  end
end
