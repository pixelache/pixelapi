class ContributorRelationSerializer
  include JSONAPI::Serializer
  attribute :relation_type, :relation_id
  attribute :relation_name do |cr|
    cr.relation.respond_to?(:name) ?  cr.relation.name : nil
  end
  attribute :relation_slug do |cr|
    cr.relation.respond_to?(:slug) ? cr.relation.slug : nil
  end
  attribute :relation_image do |cr|
    cr.relation.respond_to?(:image) ? cr.relation.image_url : nil
  end
  attribute :festival_id do |cr|
    cr.relation.respond_to?(:festival) ? cr.relation.festival.try(:slug) : nil
  end
  attribute :relation_start do |cr|
    if cr.relation_type == 'Event'
      cr.relation.start_at
    else 
      nil
    end
  end
  attribute :relation_end do |cr|
    if cr.relation_type == 'Event'
      cr.relation.end_at
    else 
      nil
    end
  end  



end
