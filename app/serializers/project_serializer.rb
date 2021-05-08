class ProjectSerializer
  include JSONAPI::Serializer
  attributes :name, :slug, :website, :parent_id, :created_at, :updated_at, :evolvedfrom_id, :evolution_year, :project_bg_colour, :project_text_colour, :active, :redirect_to, :project_link_colour
  attribute :background_url do |obj|
    obj.try(:background).try(:url)
  end
end
