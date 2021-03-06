class User < ApplicationRecord
  devise :rememberable, :trackable, :validatable, :database_authenticatable, :registerable, :recoverable, :confirmable
  include DeviseTokenAuth::Concerns::User
  rolify
  extend FriendlyId
  friendly_id :name, :use => [:slugged, :finders]
  mount_uploader :avatar, AvatarUploader

  #  associations
  has_many :authentications, :dependent => :destroy
  has_many :memberships
  has_many :posts, foreign_key: "creator_id"
  has_many :feedcaches

  accepts_nested_attributes_for :authentications, :reject_if => proc { |attr| attr['username'].blank? }

  # validations
  validates :name, presence: true
  validates :username, presence: true, uniqueness: true
  before_validation do
    self.uid = email if uid.blank?
  end
  #  scopes


  # after_create :send_new_user_email_to_nathalie_and_john
  
  def apply_omniauth(omniauth)
    if omniauth['provider'] == 'twitter'
      logger.warn(omniauth['info'].inspect)
      self.username = omniauth['info']['nickname']
      self.name = omniauth['info']['name']
      self.name.strip!
      identifier = self.username

    elsif omniauth['provider'] == 'facebook'
      self.email = omniauth['info']['email'] if email.blank?
      self.username = omniauth['info']['name'].parameterize
      logger.warn omniauth.inspect
      self.name = omniauth['info']['name']
      self.name.strip!
      identifier = self.username
      # self.location = omniauth['extra']['user_hash']['location']['name'] if location.blank?
    elsif omniauth['provider'] == 'google_oauth2'
      self.email = omniauth['info']['email'] 
      self.name = omniauth['info']['name']
      self.username = omniauth['info']['email']
      identifier = self.username
    end
    self.email = omniauth['info']['email'] if email.blank?
    self.password = SecureRandom.hex(32) if password.blank?  # generate random password to satisfy validations
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'], :username => identifier)
  end
  
  def subscribed_to?(item)
    item.subscriptions.map(&:user).include?(self)
  end

  def current_member?
    if memberships.paid.empty?
      return false
    else
      return memberships.paid.sort_by(&:year).last.year == Membership.pluck(:year).uniq.sort.last
    end
  end
  
  private
  
  def send_new_user_email_to_nathalie_and_john
    UserMailer.new_user(self).deliver rescue nil
  end
  
  def password_required?
    false
  end

  def email_required?
    true
  end

end
