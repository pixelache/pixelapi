class OpencallSerializer
  include JSONAPI::Serializer
  attributes :subsite_id, :published, :description, :is_open, :closing_date, :slug, :name, :submitted_text, :opencallquestions
  has_many :opencallquestions
end
