module V1
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :name, :email, :created, :updated
  end  
end