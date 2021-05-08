class ResidencySerializer
  include JSONAPI::Serializer
  attributes :name, :country, :start_at, :end_at, :is_micro, :photo, :project_id, :user_id, :country_override
  attributes :photo_url do |obj|
    obj.try(:photo).try(:url)
  end
end
