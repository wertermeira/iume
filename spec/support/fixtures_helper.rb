module Fixtures
  module ImageHelpers
    def image_base_64
      image = Base64.encode64(File.open(File.join(Rails.root, './spec/support/fixtures/image.jpg'), &:read))
      "data:image/jpeg;base64,#{ image }"
    end
  end
end