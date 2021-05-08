class FestivalSerializer
  include JSONAPI::Serializer
  attributes :overview_text, :name, :website, :start_at, :end_at, :slug, :subtitle, :image, :image_height, :image_width, :published

end
