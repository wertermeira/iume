require 'swagger_helper'

RSpec.describe 'v1/restaurants', type: :request do
  let(:user) { create(:owner) }
  let(:restaurant) { create(:restaurant, owner: user) }
  let(:Authorization) { '' }

  path '/v1/restaurants/{id}' do
    get 'Get restaurant' do
      tags 'Restaurants'
      produces 'application/json'
      description 'If you need to get the preview, use preview params to true and put the token'
      security [bearer: []]
      parameter name: :id, in: :path, type: :string
      parameter name: :by_id, in: :query, type: :string, required: false
      parameter name: :preview, in: :query, type: :string, required: false
      parameter name: :included, in: :query, type: :string, required: false,
                example: 'phones,address,address.city,address.city.state'

      response 200, 'restaurant found' do
        before do
          create_list(:section, 3, restaurant: restaurant, active: true)
        end
        schema type: :object,
               properties: {
                 data: {
                   '$ref' => '#/components/schemas/restaurant'
                 },
                 included: {
                   type: :array,
                   items: { type: :object },
                   example: [
                     {
                       id: '1',
                       type: 'phones',
                       attributes: {
                         number: '11-9999-9999'
                       }
                     },
                     {
                       id: '1',
                       type: 'sections',
                       attributes: {
                         name: 'Drinks',
                         description: 'Txt here',
                         position: 1
                       }
                     },
                     {
                       id: '1',
                       type: 'addresses',
                       attributes: {
                         street: Faker::Address.street_name,
                         neighborhood: Faker::Address.street_name,
                         complement: Faker::Address.community,
                         number: Faker::Address.building_number,
                         reference: Faker::Address.city_prefix,
                         cep: '44900-000'
                       },
                       relationships: {
                         cities: {
                           data: { id: '1', type: 'cities' }
                         }
                       }
                     },
                     {
                       id: '1',
                       type: 'cities',
                       attributes: {
                         name: Faker::Address.city,
                         capital: false
                       },
                       relationships: {
                         states: {
                           data: { id: '1', type: 'states' }
                         }
                       }
                     },
                     {
                       id: '1',
                       type: 'states',
                       attributes: {
                         name: Faker::Address.state,
                         acronym: 'BA'
                       }
                     }
                   ]
                 }
               }

        let(:id) { restaurant.slug }
        run_test! do
          expect(json_body.dig('data', 'relationships', 'sections', 'data').length).to eq(3)
        end
      end

      response 200, 'restaurant found by id' do
        before do
          create_list(:section, 3, restaurant: restaurant, active: false)
        end
        let(:by_id) { 'true' }
        let(:id) { restaurant.uid }
        run_test! do
          expect(json_body.dig('data', 'relationships', 'sections', 'data').length).to eq(0)
        end
      end

      response 200, 'restaurant with preview' do
        before do
          create_list(:section, 3, restaurant: restaurant, active: false)
        end

        let(:preview) { true }
        let(:Authorization) { authentication(user) }
        let(:id) { restaurant.slug }

        run_test! do
          expect(json_body.dig('data', 'relationships', 'sections', 'data')).to be_empty
        end
      end

      response 404, 'restaurant not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
