class PageSerializer
  include JSONAPI::Serializer
  attributes :name, :body, :published, :sort_order, :slug, :photos

  attributes :image  do |obj|
    unless obj.photos.empty?
      obj.photos.first
    end
  end
end
