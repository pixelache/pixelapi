class OpencallanswerSerializer
  include JSONAPI::Serializer
  attributes :opencallquestion_id, :answer
  attribute :attachment_url do |obj|
    obj.try(:attachment).try(:url)
  end
end