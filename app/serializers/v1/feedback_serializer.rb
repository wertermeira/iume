module V1
  class FeedbackSerializer < V1::BaseSerializer
    attributes :id, :screen, :body, :created_at, :updated_at
  end
end
