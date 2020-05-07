class Opencallsubmission < ActiveRecord::Base
  # associations
  belongs_to :opencall
  has_many :opencallanswers, dependent: :destroy
  has_many :comments, as: :item, :dependent => :destroy
  
  accepts_nested_attributes_for :opencallanswers

  # validations
  validates :email, presence: true
  validates :name, presence: true
  validates :phone, presence: true
  validates :country, length: { minimum: 2, maximum: 2 }, allow_blank: true
  validates :opencall, presence: true
  validate :opencall_is_open, if:  Proc.new { |a| a.dependent_attributes_valid? }

  protected

  def dependent_attributes_valid?
    [:opencall, :email, :name, :phone, :country].each do |field|
      self.class.validators_on(field).each { |v| v.validate(self) }
      return false if self.errors.messages[field].present?
    end
    return true
  end

  private

  def opencall_is_open
    errors.add(:opencall_id, I18n.t('api.errors.opencall.deadline_passed')) if opencall.closing_date.utc < Time.current.utc
  end
  
end
