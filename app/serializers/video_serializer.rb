class VideoSerializer
  include JSONAPI::Serializer
  attributes :videohost_id, :hostid, :title, :description
end
