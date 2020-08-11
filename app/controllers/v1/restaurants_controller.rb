module V1
  class RestaurantsController < V1Controller
    skip_before_action :require_login
    before_action :set_restaurant

    def show
      render json: @resturant, serializer: V1::Public::RestaurantSerializer, status: :ok, include: :sections
    end

    private

    def set_restaurant
      @resturant = if params[:by_id].present?
                     Restaurant.find_by(uid: params[:id])
                   else
                     Restaurant.find_by(slug: params[:id])
                   end
      return @restaurant if @resturant.present?

      raise ActiveRecord::RecordNotFound
    end
  end
end
