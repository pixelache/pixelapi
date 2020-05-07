class OpencallsubmissionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :phone, :email, :address, :opencall_id
  has_many :opencallanswers
end
