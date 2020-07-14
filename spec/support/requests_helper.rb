module Requests
  module JsonHelpers
    def json_body
      JSON.parse(response.body)
    end
  end

  module SerializerHelpers
    def serialized(serializer, object)
      JSON.parse(serializer.new(object).to_json)
    end

    def each_serialized(serializer, object)
      serialized = ActiveModelSerializers::SerializableResource.new(
        object, each_serializer: serializer
      ).to_json
      JSON.parse(serialized)
    end
  end

  module HeaderHelpers
    def header_with_authentication(user = nil)
      token = create(:authenticate_token, authenticator: user).body
      {
        'authorization' => "Token token=#{token}",
        'content-type' => 'application/json',
        'ACCEPT' => 'application/json'
      }
    end

    def header_without_authentication
      {
        'content-type' => 'application/json',
        'ACCEPT' => 'application/json'
      }
    end
  end
end
