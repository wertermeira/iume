module V1
  module Owners
    class FeedbacksController < V1Controller
      def create
        @feedback = Feedback.new(feedback_params.merge(owner: current_user))
        if @feedback.save
          render json: @feedback, serializer: V1::FeedbackSerializer, status: :created
        else
          render json: @feedback.errors, status: :unprocessable_entity
        end
      end

      private

      def feedback_params
        params.require(:feedback).permit(:screen, :body)
      end
    end
  end
end
