class Project < ActiveRecord::Base
  # features
  include Listable
  acts_as_tree
  translates :description, :short_description
  globalize_accessors :locales => [:en, :fi], :attributes => [:description, :short_description]
  extend FriendlyId
  friendly_id :name , :use => [ :slugged, :finders ]
  has_paper_trail
  mount_uploader :background, AttachmentUploader

  # associations
  has_and_belongs_to_many :etherpads
  has_many :events, :dependent => :nullify
  has_many :photos, as: :item
  has_many :pages
  has_many :posts
  has_many :videos
  has_many :residencies
  has_many :attachments, as: :item
  belongs_to :evolvedfrom, :class_name => 'Project', :foreign_key => "evolvedfrom_id", optional: true
  has_one :evolvedto, :class_name  => 'Project', :foreign_key => "evolvedfrom_id"
  has_many :subscriptions, as: :item
  has_one :projectproposal, foreign_key: 'offspring_id'
  accepts_nested_attributes_for :translations, :reject_if => proc {|x| x['description'].blank? && x['short_description'].blank? }
  accepts_nested_attributes_for :photos, :reject_if => proc {|x| x['filename'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :attachments, :reject_if => proc {|x| x['attachedfile'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :videos , reject_if: proc {|x| x['in_url'].blank? }, :allow_destroy => true
 
  # validations
  validates :name, presence: true, uniqueness: true

  class Translation
    validates :description, presence: true
  end

  # scopes
  scope :active, -> () { where(active: true) }
  scope :inactive, -> () { where(active: false) }
  scope :visible, -> () { where(hidden: false) }

  # callbacks
  before_save :check_listserv_support


  
  def self.active_menu
    a = Project.active.sort_by{|x| x.name }.map{|x| [x.name, x.id]}
    i = Project.inactive.sort_by{|x| x.name }.map{|x| [x.name, x.id]}
    return a + [' -- inactive/old projects -- '] + i
  end 
    
  def all_activities
    [self_and_descendants.map{|x| x.events.published}.flatten, self_and_descendants.map{|x| x.posts.published}.flatten, self_and_descendants.map{|x| x.residencies}.flatten].flatten.sort_by(&:feed_time)
  end
  
  def subscribe_path
    '/admin/projects/' + self.slug + '/subscribe'
  end
  
  def toggle_path
    '/admin/projects/' + self.slug + '/toggle_list'
  end
  
  def unsubscribe_path
    '/admin/projects/' + self.slug + '/unsubscribe'
  end
  
  def background_css
    "background-color: ##{project_bg_colour}; color: ##{project_text_colour}; "
  end
  
  def background_image_css
    if background.url.nil?
      ""
    else
      "background: url(#{background.url.gsub(/development/, 'production')}) no-repeat center center; background-size: cover; background-color:  ##{project_bg_colour}"
    end
  end

    
  def colour_offset
    "#{project_bg_colour.match(/(..)(..)(..)/).to_a[1..3].map{|x| [[0, x.hex + ( x.hex * -0.15)].max, 255].min }.map{|x| x.to_i.to_s }.join(', ')}"
  end
  
  def to_hashtag
    "##{name.gsub(/\s*/, '')}"
  end
   
  def body
    description
  end
  
  def visible?
    !hidden
  end
end
