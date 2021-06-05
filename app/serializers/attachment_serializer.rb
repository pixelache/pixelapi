class AttachmentSerializer
  include JSONAPI::Serializer
  attributes :event_id, :attachedfile_url, :item_id, :item_type, :attachedfile_content_type
  attribute :attachment_event_name do |obj|
    if obj.event
      obj.event.name
    else
      nil
    end
  end

  attribute :attachment_festival_slug do |obj|
    if obj.event
      if obj.event.festival
        obj.event.festival.slug
      else
        nil
      end
    else
      nil
    end

  end

end
 