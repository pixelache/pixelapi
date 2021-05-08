class OpencallquestionSerializer
  include JSONAPI::Serializer
  attributes :question_type, :sort_order, :character_limit, :is_required, :question_text
end
