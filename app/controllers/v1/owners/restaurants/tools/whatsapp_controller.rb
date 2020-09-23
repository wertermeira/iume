module V1
  module Owners
    module Restaurants
      module Tools
        class WhatsappController < V1Controller
          before_action :set_restaurant
          before_action :set_whatsapp, only: :index
          load_and_authorize_resource :restaurant
          load_and_authorize_resource :tool_whatsapp, through: :restaurant, through_association: :tool_whatsapp

          def index
            if @whatsapp.present?
              render json: @whatsapp, serializer: V1::Tools::WhatsappSerializer, status: :ok,
                     include: 'phone'
            else
              render json: '', status: :no_content
            end
          end

          def update
            ToolWhatsapp.create_with(tool_whatsapp_params)
                        .find_or_create_by(restaurant: @restaurant).tap do |whatsapp|
              if whatsapp.update(tool_whatsapp_params)
                render json: whatsapp, serializer: V1::Tools::WhatsappSerializer, status: :accepted, include: 'phone'
              else
                render json: whatsapp.errors, status: :unprocessable_entity
              end
            end
          end

          private

          def tool_whatsapp_params
            params.require(:whatsapp).permit(:active, :phone_id)
          end

          def set_whatsapp
            @whatsapp = @restaurant.tool_whatsapp
          end

          def set_restaurant
            @restaurant = Restaurant.find_by(uid: params[:restaurant_id])
            raise ActiveRecord::RecordNotFound if @restaurant.blank?
          end

          def current_ability
            OwnerAbility.new(current_user)
          end
        end
      end
    end
  end
end
