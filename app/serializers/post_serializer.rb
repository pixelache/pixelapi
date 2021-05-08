class PostSerializer
  include JSONAPI::Serializer
  attributes :slug, :published, :published_at, :image, :excerpt, :image_width, :image_height, :registration_required, :title, :body, :next_post_by_festival, :previous_post_by_festival
  attributes :image_url do |obj|
    obj.try(:image).try(:url)
  end
  
  attribute :creator do |obj|
    obj.creator.name
  end


end
