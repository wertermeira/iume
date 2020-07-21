module V1
  module Owners
    module Restaurants
      class SectionsController < V1Controller
        before_action :set_restaurant
        before_action :set_section, only: %i[show update destroy]

        def index
          @sections = @restaurant.sections.sort_by_position
          render json: @sections, each_serializer: V1::SectionSerializer, status: :ok
        end

        def create
          ids = @restaurant.sections.sort_by_position.ids
          @section = Section.new(section_params)
          @section.restaurant = @restaurant
          if @section.save
            position = @section.position.presence || 0
            SortableService.new(model: 'Section').update_sort(ids: ids.insert(position, @section.id))
            render json: @section, serializer: V1::SectionSerializer, status: :created
          else
            render json: @section.errors, status: :unprocessable_entity
          end
        end

        def sort
          ids = @restaurant.sections.ids
          ids.each { |id| ids.delete(id) unless @restaurant.sections.ids.include?(id) }
          SortableService.new(model: 'Section').update_sort(ids: section_params_ids.dig(:ids))

          render json: @restaurant.sections.sort_by_position, each_serializer: V1::SectionSerializer, status: :ok
        end

        def show
          render json: @section, serializer: V1::SectionSerializer, status: :ok
        end

        def update
          ids = @restaurant.sections.sort_by_position.ids
          if @section.update(section_params)
            ids -= [@section.id]
            SortableService.new(model: 'Section').update_sort(ids: ids.insert(@section.position, @section.id)) if @section.position.present?
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
          params.require(:section).permit(:name, :position, :active)
        end

        def section_params_ids
          params.require(:section).permit(ids: [])
        end
      end
    end
  end
end
