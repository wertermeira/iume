module V1
  class ProductSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers
    attributes :id, :name, :description, :price, :active, :position,
               :image, :created_at, :updated_at

    def image
      return unless object.image.attached?

      options = { resize: '256x256^', extent: '256x256', gravity: 'Center' }
      {
        original: url_for(object.image),
        small: url_for(object.image.variant(combine_options: options))
      }
    end
  end
end
