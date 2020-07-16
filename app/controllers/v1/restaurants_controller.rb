module V1
  class RestaurantsController < V1Controller
    before_action :set_restaurant, only: %i[show update]
    skip_before_action :require_login, only: :create

    def create
      @restaurant = Restaurant.new(restaurant_params)
      if @restaurant.save
        token = AuthService.create_token(authenticator: @restaurant, request: request)
        render json: { token: token }, status: :created
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
      render json: @restaurant, serializer: V1::RestaurantSerializer, status: :ok
    end

    private

    def set_restaurant
      @restaurant = current_user
    end

    def restaurant_params
      params.require(:restaurant).permit(:name, :email, :password, :password_confirmation)
    end
  end
end
