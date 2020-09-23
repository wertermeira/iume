require 'swagger_helper'

RSpec.describe '/v1/owners/restaurants/:restaurant_id/tools/whatsapp', type: :request, swagger_doc: 'v1/swagger_owner.yaml' do
  TAG = 'ToolsWhatsapp'.freeze
  let(:user) { create(:owner) }
  let(:restaurant) { create(:restaurant, owner: user) }
  let(:phone) { create(:phone, phoneable: restaurant) }
  let(:Authorization) { authentication(user) }

  path '/v1/owners/restaurants/{restaurant_id}/tools/whatsapp' do
    get 'show whatsapp' do
      let(:restaurant_id) { restaurant.uid }
      tags TAG
      produces 'application/json'
      security [bearer: []]
      parameter name: :restaurant_id, in: :path, type: :string
      parameter name: :included, in: :query, type: :string, required: false,
                example: 'phone,phone.restaurant'

      response 200, 'show ToolWhatsapp' do
        before do
          create(:address, addressable: restaurant)
          create(:tool_whatsapp, restaurant: restaurant, phone: phone, active: true)
        end
        schema '$ref' => '#/components/schemas/tools_whatsapp'
        run_test!
      end

      response 204, 'no content' do
        run_test!
      end
    end

    put 'Update whatsapp' do
      before do
        create(:address, addressable: restaurant)
      end
      let(:restaurant_id) { restaurant.uid }
      let(:whatsapp_attributes) {
        {
          whatsapp: {
            active: true,
            phone_id: phone.id
          }
        }
      }

      tags TAG
      consumes 'application/json'
      produces 'application/json'
      security [bearer: []]
      description 'To activate this option, the restaurant must have an address'
      parameter name: :restaurant_id, in: :path, type: :string
      parameter name: :included, in: :query, type: :string, required: false,
                example: 'phone,phone.restaurant'
      parameter name: :whatsapp, in: :body, schema: {
        type: :object,
        properties: {
          whatsapp: {
            type: :object,
            properties: {
              phone_id: { type: :integer, example: '1' },
              active: { type: :boolean }
            },
            required: %w[phone_id]
          }
        }
      }
      response 202, 'update whatsapp existing' do
        before do
          whatsapp_attributes[:whatsapp][:active] = false
          create(:tool_whatsapp, restaurant: restaurant, phone: phone, active: true)
        end
        let(:whatsapp) { whatsapp_attributes }

        schema '$ref' => '#/components/schemas/tools_whatsapp'
        run_test! do
          expect(json_body.dig('data', 'attributes', 'active')).to be_falsey
          expect(json_body.dig('included').select { |item| item['type'] == 'phones' }).to be_truthy
        end
      end

      response 202, 'update whatsapp' do
        let(:whatsapp) { whatsapp_attributes }

        schema '$ref' => '#/components/schemas/tools_whatsapp'
        run_test! do
          expect(json_body.dig('data', 'attributes', 'active')).to be_truthy
          expect(json_body.dig('included').select { |item| item['type'] == 'phones' }).to be_truthy
        end
      end

      response 422, 'update whatsapp fail' do
        before do
          whatsapp_attributes[:whatsapp][:phone_id] = create(:phone).id
        end
        let(:whatsapp) { whatsapp_attributes }
        schema type: :object,
               properties: {
                 phone_id: { type: :array, items: { type: :string, example: I18n.t('errors.messages.invalid') } }
               }
        run_test! do
          expect(json_body['phone_id']).to match_array([I18n.t('errors.messages.invalid')])
        end
      end
    end
  end
end
