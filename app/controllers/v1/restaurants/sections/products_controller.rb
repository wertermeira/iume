module V1
  module Restaurants
    module Sections
      class ProductsController < V1Controller
        skip_before_action :require_login
        before_action :set_section
        before_action :set_product, only: :show

        def index
          @products = @section.products.published.sort_by_position
          render json: @products, each_serializer: V1::Public::ProductSerializer, status: :ok
        end

        def show
          render json: @product, serializer: V1::Public::ProductSerializer, status: :ok
        end

        private

        def set_product
          @product = Product.published.find(params[:id])
        end

        def set_section
          @section = Section.published.find(params[:section_id])
        end
      end
    end
  end
end
