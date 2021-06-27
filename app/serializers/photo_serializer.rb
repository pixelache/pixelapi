class PhotoSerializer
  include JSONAPI::Serializer
  attributes :item_id, :filename_url, :item_type, :filename_content_type, :filename_width, :filename_height, :title, :credit

  attribute :filename_box_url do |obj|
    obj.filename_url(:box)
  end
  attribute :filename_thumb_url do |obj|
    obj.filename_url(:thumb)
  end
  attribute :filename_filename do |obj|
    obj.filename.filename
  end
  attribute :filename_event_name do |obj|
    if obj.item_type == 'Event'
      obj.item.name
    else
      nil
    end
  end

  attribute :filename_item_slug do |obj|
    if obj.item.respond_to?(:slug)
      obj.item.slug
    else
      nil
    end
  end

end
 
