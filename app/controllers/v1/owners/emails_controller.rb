module V1
  module Owners
    class EmailsController < V1Controller
      skip_before_action :require_login

      def show
        return email_blank if params[:email].blank?

        owner = Owner.find_by(email: params[:email].downcase)
        raise ActiveRecord::RecordNotFound if owner.blank?

        render json: '', status: :ok
      end

      private

      def email_blank
        render json: { email: [I18n.t('errors.messages.blank')] }, status: :unprocessable_entity
      end
    end
  end
end
