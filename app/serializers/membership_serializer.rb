class MembershipSerializer
  include JSONAPI::Serializer
  attributes :year, :user_id, :paid, :hallitus, :hallitus_alternate, :notes
  belongs_to :user
end
