class OpencallanswerSerializer
  include FastJsonapi::ObjectSerializer
  attributes :opencallquestion_id, :answer
  attribute :attachment_url do |obj|
    obj.try(:attachment).try(:url)
  end
end