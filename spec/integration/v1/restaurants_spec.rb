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
                   items: { '$ref' => '#/components/schemas/section' }
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
