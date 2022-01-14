class UserSerializer
  include JSONAPI::Serializer
  attributes :name, :avatar, :website, :bio, :twitter_name
end