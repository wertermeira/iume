module V1
  module Owners
    class ThemeColorsController < V1Controller
      def index
        @colors = ThemeColor.all.order(id: :asc)
        render json: @colors, each_serializer: V1::ThemeColorSerializer, status: :ok
      end
    end
  end
end
