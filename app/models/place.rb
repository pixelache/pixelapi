class Place < ActiveRecord::Base
  # features
  translates :name, :fallbacks_for_empty_translations => true
  globalize_accessors :locales => [:en, :fi], :attributes => [:name]
  extend FriendlyId
  friendly_id :name_en, :use => [:finders, :history]
  geocoded_by :address

  # associations
  accepts_nested_attributes_for :translations, :reject_if => proc {|x| x['name'].blank? }
  has_many :events, :dependent => :restrict_with_error
  
  # validations
  validates :address1, presence: true
  validates :country, presence: true, length: { minimum: 2, maximum: 2 }, allow_blank: false
  validates :city, presence: true

  class Translation
    validates :name, presence: true
  end

  # hooks + callbacks
  after_validation :geocode, :on => :create
  # before_destroy :check_for_events

  # def name_en
  #   self.name(:en)
  # end

  def address
    [address1 , address2, city, country, postcode].delete_if {|x| x.blank? }.compact.join(', ')
  end
  
  def address_no_country
    [address1 , address2, city].delete_if {|x| x.blank? }.compact.join(', ')
  end

  private

  def check_for_events
    if events.published.count > 0
      errors.add_to_base('You cannot delete this place because events in the past have taken place there.')
    end
  end


end
