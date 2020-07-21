module V1
  module Owners
    class EmailsController < V1Controller
      skip_before_action :require_login

      def show
        owner = Owner.find_by(email: params[:email]&.downcase)
        raise ActiveRecord::RecordNotFound if owner.blank?

        render json: '', status: :ok
      end
    end
  end
end
