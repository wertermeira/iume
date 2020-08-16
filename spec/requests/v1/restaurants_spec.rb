require 'swagger_helper'

RSpec.describe 'v1/restaurants', type: :request do
  let(:restaurant) { create(:restaurant) }
  path '/v1/restaurants/{id}' do
    get 'Get restaurant' do
      tags 'Restaurants'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :by_id, in: :query, type: :string, required: false

      response 200, 'restaurant found' do
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
        run_test!
      end

      response 200, 'restaurant found by id' do
        let(:by_id) { 'true' }
        let(:id) { restaurant.uid }
        run_test!
      end

      response 404, 'restaurant not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
