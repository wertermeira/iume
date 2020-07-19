module V1
  class OwnersController < V1Controller
    before_action :set_owner, only: %i[show update]
    skip_before_action :require_login, only: :create

    def create
      @owner = Owner.new(owner_params)
      if @owner.save
        token = AuthService.create_token(authenticator: @owner, request: request)
        render json: { token: token }, status: :created
      else
        render json: @owner.errors, status: :unprocessable_entity
      end
    end

    def update
      if @owner.update(owner_params)
        render json: @owner, serializer: V1::OwnerSerializer, status: :accepted
      else
        render json: @owner.errors, status: :unprocessable_entity
      end
    end

    def show
      render json: @owner, serializer: V1::OwnerSerializer, status: :ok
    end

    private

    def set_owner
      @owner = current_user
    end

    def owner_params
      params.require(:owner).permit(:name, :email, :password, :password_confirmation)
    end
  end
end
