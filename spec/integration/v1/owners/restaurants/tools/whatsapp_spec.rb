require 'swagger_helper'

RSpec.describe '/v1/owners/restaurants/:restaurant_id/tools/whatsapp', type: :request, swagger_doc: 'v1/swagger_owner.yaml' do
  TAG = 'ToolsWhatsapp'.freeze
  let(:user) { create(:owner) }
  let(:restaurant) { create(:restaurant, owner: user) }
  let(:Authorization) { authentication(user) }

  path '/v1/owners/restaurants/{restaurant_id}/tools/whatsapp' do
    get 'show whatsapp' do
      let(:restaurant_id) { restaurant.uid }
      tags TAG
      produces 'application/json'
      security [bearer: []]
      parameter name: :restaurant_id, in: :path, type: :string
      parameter name: :included, in: :query, type: :string, required: false,
                example: 'phone'

      response 200, 'show ToolWhatsapp' do
        before do
          create(:address, addressable: restaurant)
          create(:tool_whatsapp, restaurant: restaurant, active: true)
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
      let(:included) { 'phone,phone.restaurant' }
      let(:restaurant_id) { restaurant.uid }
      let(:whatsapp_attributes) {
        {
          whatsapp: {
            active: true,
            phone_attributes: {
              number: '11-99999-0000'
            }
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
                example: 'phone'
      parameter name: :whatsapp, in: :body, schema: {
        type: :object,
        properties: {
          whatsapp: {
            type: :object,
            properties: {
              phone_attributes: {
                type: :object,
                properties: {
                  number: { type: :string, example: '11-9999-9999' },
                  _destroy: { type: :boolean }
                },
                required: %w[number]
              },
              active: { type: :boolean }
            },
            required: %w[phone_attributes]
          }
        }
      }
      response 202, 'update whatsapp existing' do
        before do
          whatsapp_attributes[:whatsapp][:active] = false
          create(:tool_whatsapp, restaurant: restaurant, active: true)
        end
        let(:whatsapp) { whatsapp_attributes }

        schema '$ref' => '#/components/schemas/tools_whatsapp'
        run_test! do
          expect(json_body.dig('data', 'attributes', 'active')).to be_falsey
          expect(json_body.dig('included').select { |item| item['type'] == 'phones' }).to be_truthy
        end
      end

      response 202, 'update whatsapp remove phone' do
        let!(:tool_whatsapp) {
          create(:tool_whatsapp, restaurant: restaurant, active: true)
        }
        before do
          whatsapp_attributes[:whatsapp][:phone_attributes][:_destroy] = true
        end
        let(:whatsapp) { whatsapp_attributes }

        schema '$ref' => '#/components/schemas/tools_whatsapp'
        run_test! do
          expect(json_body.dig('data', 'attributes', 'active')).to be_falsey
          expect(tool_whatsapp.reload.phone).to be_falsey
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
          whatsapp_attributes[:whatsapp][:phone_attributes][:number] = ''
        end
        let(:whatsapp) { whatsapp_attributes }
        schema type: :object,
               properties: {
                 phone: { type: :array, items: { type: :string, example: I18n.t('errors.messages.blank') } }
               }
        run_test! do
          expect(json_body['phone']).to match_array([I18n.t('errors.messages.blank')])
        end
      end
    end
  end
end
