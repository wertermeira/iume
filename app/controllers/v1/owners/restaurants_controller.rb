module V1
  module Owners
    class RestaurantsController < V1Controller
      before_action :set_restaurant, only: %i[show update]

      def index
        @restaurants = current_user.restaurants
        render json: @restaurants, each_serializer: V1::RestaurantSerializer, status: :ok
      end

      def show
        render json: @restaurant, serializer: V1::RestaurantSerializer, status: :ok
      end

      def create
        raise ArgumentError.new(message: 'Limit') if current_user.restaurants.present?

        @restaurant = Restaurant.new(restaurant_params.except(:slug))
        @restaurant.owner = current_user
        if @restaurant.save
          render json: @restaurant, serializer: V1::RestaurantSerializer, status: :created
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

      private

      def set_restaurant
        @restaurant = current_user.restaurants.find(params[:id])
      end

      def restaurant_params
        params.require(:restaurant).permit(:name, :slug)
      end
    end
  end
end
