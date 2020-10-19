module V1
  class SocialNetworkSerializer < V1::BaseSerializer
    attributes :id, :username, :provider
  end
end
