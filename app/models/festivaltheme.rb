class Festivaltheme < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name_en, use: [:slugged, :finders, :scoped], :scope => :festival
  translates :name, :description, :short_description, fallbacks_for_empty_translations: true
  globalize_accessors :locales => [:en, :fi], :attributes => [:name, :description, :short_description]
  mount_base64_uploader :image, ImageUploader

  belongs_to :festival  
  has_many :festivaltheme_relations
  has_many :events, through: :festivaltheme_relations, source_type: 'Event', source: :relation, foreign_key: :relation_id
  has_many :pages, through: :festivaltheme_relations, source_type: 'Page', source: :relation  
  has_many :posts, through: :festivaltheme_relations, source_type: 'Post', source: :relation, foreign_key: :relation_id
  has_many :contributors, through: :festivaltheme_relations, source_type: 'Contributor', source: :relation, foreign_key: :relation_id
  has_many :experiences
  accepts_nested_attributes_for :translations, reject_if: proc {|x| x['name'].blank? }

  validates :festival, presence: true
  validate :name_present_in_at_least_one_locale

  before_save :update_image_attributes

  class Translation
    validates :name, presence: true, uniqueness: { scope: :festivaltheme_id }
  end

  def name_present_in_at_least_one_locale
    if I18n.available_locales.map { |locale| translation_for(locale).name }.compact.empty?
      errors.add(:base, "You must specify a theme name in at least one available language.")
    end
  end

  def name_and_festival
    [name, festival.name].join(' / ')
  end
  
  def name_en
    self.name(:en)
  end
  
  def update_image_attributes
    if image.present? && image_changed?
      if image.file.exists?
        self.image_content_type = image.file.content_type
        self.image_file_size = image.file.size
        self.image_width, self.image_height = `identify -format "%wx%h" #{image.file.path}`.split(/x/)
      end
    end
  end
  
end
