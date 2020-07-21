module V1
  module Owners
    module Restaurants
      module Sections
        class ProductsController < V1Controller
          before_action :set_product, only: %i[show update destroy]

          def index
            @products = @section.products
            render json: @products, status: :ok
          end

          def create
            @product = Product.new(product_params.expect(:section_id))
            if @product.save
              render json: @product, status: :created
            else
              render json: @products.errors, status: :unprocessable_entity
            end
          end

          def update
            if @product.update(product_params)
              render json: @product, status: :accepted
            else
              render json: @products.errors, status: :unprocessable_entity
            end
          end

          def show
            render json: @product, status: :ok
          end

          def destroy
            @product.destroy
            head :no_content
          end

          private

          def set_product
            @product = Product.find(params[:id])
          end

          def product_params
            params.require(:product).permit(:name, :description, :active, :section_id, image: [:data])
          end
        end
      end
    end
  end
end