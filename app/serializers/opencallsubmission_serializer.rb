class OpencallsubmissionSerializer
  include JSONAPI::Serializer
  attributes :name, :phone, :email, :address, :opencall_id
  has_many :opencallanswers
end
