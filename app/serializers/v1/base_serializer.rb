module V1
  class BaseSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers

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
