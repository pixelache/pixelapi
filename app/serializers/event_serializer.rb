class EventSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :notes, :subsite_id, :place_id, :start_at, :end_at, :published, :image_url, :image_width, :image_height, :image_content_type, :image_size, :facebook_link, :cost, :cost_alternate, :cost_alternate_reason, :created_at, :updated_at, :slug, :facilitator_name, :facilitator_url, :facilitator_organisation, :facilitator_organisation_url, :project_id, :festival_id, :user_id, :max_attendees, :eventr_id, :residency_id, :festivaltheme_id, :registration_required, :question_description, :question_creators, :question_motivation, :require_approval, :hide_registrants, :show_guests_to_public, :location_tbd, :external_registration, :stream_url

  attribute :image_box_url do |obj|
    if obj.image?
      obj.image.url(:box)
    else
      nil
    end
  end
  attribute :image_thumb_url do |obj|
    if obj.image?
      obj.image.url(:thumb)
    else
      nil
    end
  end
  
  attribute :is_full do |obj|
    obj.is_full?
  end
  attribute :free_places do |obj|
    if obj.max_attendees 
      obj.max_attendees - obj.attendees.not_waiting.count
    else
      nil
    end
  end

  belongs_to :place, serializer: PlaceSerializer
  has_many :contributors
  has_many :contributor_relations
  has_many :festivalthemes
end
