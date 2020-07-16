module V1
  module Owners
    class SessionsController < V1Controller
      skip_before_action :require_login, only: :create
      before_action :sanitize_sessions_params, only: :create

      def create
        validation = LoginValidation.new(session_params.merge(model: Owner))
        return response_unprocessable_entity(validation.errors) unless validation.valid?

        if user.find_by(email: session_params.dig(:email)).authenticate(session_params.dig(:password))
          token = AuthService.create_token(authenticator: user, request: request)
          render json: { token: token }, status: :created
        else
          response_unprocessable_entity({ password: [I18n.t('errors.messages.invalid_password')] })
        end
      end

      def destroy
        AuthService.destroy_token(authenticator: current_user, request: request)

        head :no_content
      end

      private

      def response_unprocessable_entity(response)
        render json: response, status: :unprocessable_entity
      end

      def session_params
        params.require(:login).permit(:email, :password, :access_token)
      end

      def sanitize_sessions_params
        params[:login][:email] = params[:login][:email]&.downcase
      end
    end
  end
end
