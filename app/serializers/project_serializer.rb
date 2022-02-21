class ProjectSerializer
  include JSONAPI::Serializer
  attributes :name, :slug, :website, :parent_id, :created_at, :updated_at, :evolvedfrom_id, :evolvedto_id, :evolution_year, :project_bg_colour, :project_text_colour, :active, :redirect_to, :project_link_colour
  attribute :background_url do |obj|
    obj.try(:background).try(:url)
  end
  attribute :first_activity do |proj|
    proj.all_activities&.first&.feed_time
  end
  attribute :last_activity do |proj|
    proj.all_activities&.last&.feed_time
  end
  attribute :children_ids do |proj|
    proj.children.map(&:id)
  end
  attributes :evolvedfrom_name do |proj|
    proj.evolvedfrom_id.present? ? proj.evolvedfrom.name : nil
  end
  attributes :evolvedto_name do |proj|
    proj.evolvedto_id.present? ? proj.evolvedto.name : nil
  end
end
