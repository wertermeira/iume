module V1
  module Owners
    module Restaurants
      module Sections
        class ProductsController < V1Controller
          before_action :set_product, only: %i[show update destroy]
          before_action :set_section
          load_and_authorize_resource :section
          load_and_authorize_resource through: :section, shallow: false

          def index
            @products = @section.products.sort_by_position
            render json: @products, each_serializer: V1::ProductSerializer, status: :ok
          end

          def create
            ids = @section.products.sort_by_position.ids
            @product = Product.new(product_params.except(:section_id, :image_destroy))
            @product.section = @section
            if @product.save
              position = @section.position.presence || 0
              SortableService.new(model: 'Product').update_sort(ids: ids.insert(position, @product.id))
              render json: @product, serializer: V1::ProductSerializer, status: :created
            else
              render json: @product.errors, status: :unprocessable_entity
            end
          end

          def update
            ids = section_select.products.sort_by_position.ids
            if @product.update(product_params)
              ids -= [@product.id]
              SortableService.new(model: 'Product').update_sort(ids: ids.insert(@product.position, @product.id)) if @product.position.present?
              render json: @product, serializer: V1::ProductSerializer, status: :accepted
            else
              render json: @product.errors, status: :unprocessable_entity
            end
          end

          def sort
            ids = @section.products.ids
            ids.each { |id| ids.delete(id) unless @section.products.ids.include?(id) }
            SortableService.new(model: 'Product').update_sort(ids: product_params_ids.dig(:ids))

            render json: @section.products.sort_by_position, each_serializer: V1::ProductSerializer, status: :ok
          end

          def show
            render json: @product, serializer: V1::ProductSerializer, status: :ok
          end

          def destroy
            @product.destroy
            head :no_content
          end

          private

          def section_select
            return Section.find(product_params[:section_id]) if product_params[:section_id].present?

            @section
          end

          def set_product
            @product = Product.find(params[:id])
          end

          def set_section
            @section = Section.find(params[:section_id])
          end

          def product_params
            params.require(:product).permit(:name, :description, :position, :active, :price, :section_id, :image_destroy, image: [:data])
          end

          def product_params_ids
            params.require(:product).permit(ids: [])
          end

          def current_ability
            OwnerAbility.new(current_user)
          end
        end
      end
    end
  end
end
