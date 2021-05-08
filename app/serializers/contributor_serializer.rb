class ContributorSerializer
  include JSONAPI::Serializer
  attributes :name, :alphabetical_name, :slug, :bio, :image_url, :website
  has_many :contributor_relations
  has_many :festivalthemes
end
