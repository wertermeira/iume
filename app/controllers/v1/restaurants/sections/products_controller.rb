module V1
  module Restaurants
    module Sections
      class ProductsController < V1Controller
        skip_before_action :require_login, unless: :preview
        before_action :set_section
        before_action :set_product, only: :show

        def index
          @products = @section.products.sort_by_position if preview
          @products ||= @section.products.published.sort_by_position
          render json: @products, each_serializer: V1::Public::ProductSerializer, status: :ok
        end

        def show
          render json: @product, serializer: V1::Public::ProductSerializer, status: :ok
        end

        private

        def set_product
          @product = if preview.present?
                       @section.products.find(params[:id])
                     else
                       Product.published.find(params[:id])
                     end
        end

        def set_section
          @section = if preview.present?
                       current_user.sections.find(params[:section_id])
                     else
                       Section.published.find(params[:section_id])
                     end
        end

        def preview
          params[:preview].present?
        end
      end
    end
  end
end
