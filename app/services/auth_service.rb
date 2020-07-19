class AuthService
  class << self
    def create_token(authenticator:, request: nil)
      token = expire_token(authenticator: authenticator, request: request)
      return token if token.present?

      create_auth = AuthenticateToken.new(
        authenticateable_type: authenticator.class.name,
        authenticateable_id: authenticator.id,
        user_agent: request&.user_agent,
        ip_address: request&.remote_ip,
        last_used_at: Time.now.utc
      )
      create_auth.body if create_auth.save
    end

    def find_token(token)
      auth = AuthenticateToken.find_by(body: token)
      return if auth.blank?

      auth.authenticated
    end

    def expire_token(authenticator:, request: nil)
      token = authenticator.authenticate_tokens.find_by(user_agent: request&.user_agent)

      return if token.blank?

      token.update_token
      token.reload
      token.body
    end

    def destroy_token(authenticator:, request: nil)
      token = authenticator.authenticate_tokens.find_by(user_agent: request&.user_agent)

      return if token.blank?

      token.destroy
    end
  end
end
