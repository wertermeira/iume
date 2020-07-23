class V1Controller < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  rescue_from CanCan::AccessDenied, with: :autorization_error
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ArgumentError, with: :argument_error
  before_action :require_login

  private

  def current_user
    @authenticate_token
  end

  def require_login
    auth = authenticate_token
    if auth
      @authenticate_token = auth
    else
      render_unauthorized('Access denied')
    end
  end

  def authenticate_token
    authenticate_with_http_token do |token|
      AuthService.find_token(token)
    end
  end

  def record_not_found
    render json: { errors: { status: 404, message: 'not found' } }, status: :not_found
  end

  def argument_error(error)
    render json: { errors: { status: 422, message: error.message } }, status: :unprocessable_entity
  end

  def render_unauthorized(message)
    render json: { errors: { status: 401, message: message } }, status: :unauthorized
  end

  def autorization_error
    render json: { errors: { status: 401, message: 'Not autorization' } }, status: :unauthorized
  end
end
