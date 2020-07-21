module V1
  module Owners
    class RestaurantsController < V1Controller
      before_action :set_restaurant, only: %i[show update]
      load_and_authorize_resource

      def index
        @restaurants = Restaurant.accessible_by(current_ability)
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
        @restaurant = Restaurant.find(params[:id])
      end

      def restaurant_params
        params.require(:restaurant).permit(:name, :slug, :active)
      end

      def current_ability
        OwnerAbility.new(current_user)
      end
    end
  end
end
