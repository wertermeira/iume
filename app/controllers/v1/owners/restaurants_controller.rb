module V1
  module Owners
    class RestaurantsController < V1Controller
      before_action :set_restaurant, only: %i[show update]
      load_and_authorize_resource

      def index
        @restaurants = Restaurant.accessible_by(current_ability)
        render json: @restaurants, each_serializer: V1::RestaurantSerializer, status: :ok, include: included_serializer
      end

      def show
        render json: @restaurant, serializer: V1::RestaurantSerializer, status: :ok, include: included_serializer
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
          render json: @restaurant, serializer: V1::RestaurantSerializer, status: :accepted, include: included_serializer
        else
          render json: @restaurant.errors, status: :unprocessable_entity
        end
      end

      def availability_slug
        validation = AvailabilitySlugValidation.new(availability_slug_params)
        if validation.valid?
          render json: '', status: :accepted
        else
          render json: validation.errors, status: :unprocessable_entity
        end
      end

      private

      def availability_slug_params
        params.require(:restaurant).permit(:slug)
      end

      def set_restaurant
        @restaurant = Restaurant.find_by(uid: params[:id])
        raise ActiveRecord::RecordNotFound if @restaurant.blank?
      end

      def restaurant_params
        address_attributes = %i[id street neighborhood complement reference number cep]
        params.require(:restaurant).permit(:name, :slug, :active, :image_destroy, image: [:data],
                                                                                  phones_attributes: %i[id number _destroy],
                                                                                  address_attributes: address_attributes)
      end

      def current_ability
        OwnerAbility.new(current_user)
      end

      def included_serializer
        return params[:included] if request.get?

        'sections,phones,address,address.city,address.city.state'
      end
    end
  end
end
