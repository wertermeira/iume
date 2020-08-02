module V1
  class FeedbackSerializer < ActiveModel::Serializer
    attributes :id, :screen, :body, :created_at, :updated_at
  end
end
