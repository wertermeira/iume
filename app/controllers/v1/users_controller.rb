module V1
  class UsersController < V1Controller
    def create
      @user = User.new(user_params)
      if @user.save
        render json: @user, serializer: V1::UserSerializer, status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    def update
      if @user.update(user_params)
        render json: @user, serializer: V1::UserSerializer, status: :accepted
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    def show
      render json: current_user, serializer: V1::UserSerializer, status: :ok
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  end
end