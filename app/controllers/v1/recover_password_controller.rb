module V1
  class RecoverPasswordController < V1Controller
    skip_before_action :require_login, only: :create

    def create
      raise ActiveRecord::RecordNotFound unless %w[owner].include?(params[:model])

      model = params[:model].classify.safe_constantize.find_by(email: password_params.dig(:email))
      if model
        token = AuthService.create_token(authenticator: model, request: request)
        render json: { message: I18n.t('mailer.messages.check_your_mailbox') }, status: :created
      else
        render json: { errors: { email: I18n.t('errors.messages.email_not_found') } },
               status: :unprocessable_entity
      end
    end

    def update
      current_user.attributes = password_params.except(:email)
      if current_user.save(context: :update_password)
        render json: '', status: :accepted
      else
        render json: current_user.errors, status: :unprocessable_entity
      end
    end

    private

    def password_params
      params.require(:recover).permit(:password, :password_confirmation, :email)
    end
  end
end
