module V1
  module Restaurants
    class OrdersController < V1Controller
      skip_before_action :require_login
      before_action :set_restaurant

      def create
        @order = Order.new(order_params.merge(restaurant: @restaurant))
        if @order.save(context: :endpoint)
          render json: '', status: :created
        else
          render json: @order.errors, status: :unprocessable_entity
        end
      end

      private

      def set_restaurant
        @restaurant = Restaurant.find_by(uid: params[:restaurant_id])

        raise ActiveRecord::RecordNotFound if @restaurant.blank?
      end

      def order_params
        params.require(:order).permit(order_details_attributes: %i[product_id quantity])
      end
    end
  end
end
