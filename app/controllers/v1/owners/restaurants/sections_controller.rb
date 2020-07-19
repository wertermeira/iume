module V1
  module Owners
    module Restaurants
      class SectionsController < V1Controller
        before_action :set_restaurant
        before_action :set_section, only: %i[show update destroy]
  
        def index
          @sections = @restaurant.sections
          render json: @sections, each_serializer: V1::SectionSerializer, status: :ok
        end

        def create
          @section = Section.new(section_params)
          @section.restaurant = @restaurant
          if @section.save
            render json: @section, serializer: V1::SectionSerializer, status: :created
          else
            render json: @section.errors, status: :unprocessable_entity
          end
        end

        def show
          render json: @section, serializer: V1::SectionSerializer, status: :ok
        end

        def update
          if @section.update(section_params)
            render json: @section, serializer: V1::SectionSerializer, status: :accepted
          else
            render json: @section.errors, status: :unprocessable_entity
          end
        end

        def destroy
          @section.destroy
          head :no_content
        end

        private

        def set_section
          @section = @restaurant.sections.find(params[:id])
        end

        def set_restaurant
          @restaurant = current_user.restaurants.find(params[:restaurant_id])
        end

        def section_params
          params.require(:section).permit(:name, :position)
        end
      end
    end
  end
end