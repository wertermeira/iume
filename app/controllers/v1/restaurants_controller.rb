module V1
  class RestaurantsController < V1Controller
    skip_before_action :require_login
    before_action :set_restaurant

    def show
      render json: @resturant, serializer: V1::Public::RestaurantSerializer, status: :ok, include: :sections
    end

    private

    def set_restaurant
      @resturant = Restaurant.find_by(slug: params[:id])
      return @restaurant if @resturant.present?

      raise ActiveRecord::RecordNotFound
    end
  end
end
