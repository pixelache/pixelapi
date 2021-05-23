class PlaceSerializer
  include JSONAPI::Serializer
  attributes :name, :address1, :address2, :city, :country, :postcode, :latitude, :longitude, :created_at, :updated_at, :slug, :address_no_country
end
