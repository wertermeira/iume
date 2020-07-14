module V1
  class RestaurantsController < V1Controller
    def create
      @restaurant = Restaurant.new(restaurant_params)
      if @restaurant.save
        token = AuthService.create_token(authenticator: @user, request: request)
        render json: token, status: :created
      else
        render json: @restaurant.errors, status: :unprocessable_entity
      end
    end

    def update
      if @restaurant.update(restaurant_params)
        render json: @restaurant, serializer: V1::RestaurantSerializer, status: :accepted
      else
        render json: @restaurant.errors, status: :unprocessable_entity
      end
    end

    def show
      render json: current_restaurant, serializer: V1::RestaurantSerializer, status: :ok
    end

    private

    def restaurant_params
      params.require(:restaurant).permit(:name, :email, :password, :password_confirmation)
    end
  end
end
