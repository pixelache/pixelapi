class FestivalthemeSerializer
  include JSONAPI::Serializer
  attributes :slug, :name, :description, :short_description, :image, :created_at, :updated_at, :image_width, :image_height, :image_file_size, :image_content_type, :image_url
end
