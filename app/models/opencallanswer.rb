class Opencallanswer < ActiveRecord::Base
  mount_base64_uploader :attachment, AttachmentUploader

  # associations
  belongs_to :opencallsubmission
  belongs_to :opencallquestion

  # validations
  validates :opencallquestion, presence: true
  validates :opencallsubmission, presence: true
  validate :valid_answer?, if: Proc.new { |a| a.dependent_attributes_valid? }

  #protected

  def dependent_attributes_valid?
    [:opencallsubmission, :opencallquestion].each do |field|
      self.class.validators_on(field).each { |v| v.validate(self) }
      return false if self.errors.messages[field].present?
    end
    return true
  end

  def valid_answer?
    if opencallquestion.question_type == 3
      errors.add(:attachment, I18n.t('api.errors.opencall.answer.missing_attachment')) if attachment.blank?
    else
      errors.add(:answer, I18n.t('api.errors.opencall.answer.missing_answer')) if answer.blank?
    end
  end

end
