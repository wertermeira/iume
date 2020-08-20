module V1
  class OwnersController < V1Controller
    before_action :set_owner, only: %i[show update]
    skip_before_action :require_login, only: :create

    def create
      @owner = Owner.new(owner_params)
      if @owner.save
        token = AuthService.create_token(authenticator: @owner, request: request)
        WelcomeMailer.send_to_owner(@owner).deliver_later!
        render json: { token: token }, status: :created
      else
        render json: @owner.errors, status: :unprocessable_entity
      end
    end

    def update
      password_params = owner_params.except(:name, :password_confirmation).merge(current_user: current_user)
      @owner_password_validation = OwnerPasswordValidation.new(password_params)
      return render_invalid_password unless @owner_password_validation.valid?

      if @owner.update(owner_params.except(:password_current))
        render json: @owner, serializer: V1::OwnerSerializer, status: :accepted
      else
        render json: @owner.errors, status: :unprocessable_entity
      end
    end

    def show
      render json: @owner, serializer: V1::OwnerSerializer, status: :ok
    end

    def destroy
      current_user.destroy
      head :no_content
    end

    private

    def set_owner
      @owner = current_user
    end

    def owner_params
      params.require(:owner).permit(:name, :email, :password, :password_confirmation, :password_current)
    end

    def render_invalid_password
      render json: @owner_password_validation.errors, status: :unprocessable_entity
    end
  end
end
