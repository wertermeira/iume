require 'swagger_helper'

RSpec.describe 'v1/restaurants/sections/{section_id}/products', type: :request do
  DESCRIPTION = 'If you need to get the preview, use preview params to true and put the token'.freeze

  let(:user) { create(:owner) }
  let(:restaurant) { create(:restaurant, owner: user) }
  let(:section) { create(:section, restaurant: restaurant) }
  let(:product) { create(:product, section: section) }
  let(:Authorization) { '' }

  path '/v1/restaurants/sections/{section_id}/products' do
    before do
      create_list(:product, 10, section_id: section.id)
      create_list(:product, 10, section_id: section.id, active: false)
    end

    get 'All products of a section' do
      tags 'Products'
      produces 'application/json'
      description DESCRIPTION
      security [bearer: []]
      parameter name: :section_id, in: :path, type: :integer
      parameter name: :preview, in: :query, type: :string, required: false

      response '200', 'products array' do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: {
                     '$ref' => '#/components/schemas/product'
                   }
                 }
               }
        let(:section_id) { section.id }
        run_test! do
          expect(json_body.dig('data').length).to eq(10)
        end
      end

      response '200', 'products array preview' do
        let(:Authorization) { authentication(user) }
        let(:section_id) { section.id }
        let(:preview) { true }
        run_test! do
          expect(json_body.dig('data').length).to eq(20)
        end
      end

      response '404', 'section not found' do
        let(:section_id) { '0' }
        run_test!
      end
    end
  end

  path '/v1/restaurants/sections/{section_id}/products/{id}' do
    before { create_list(:product, 10, section_id: section.id) }

    get 'Get product by section id and product id' do
      tags 'Products'
      produces 'application/json'
      security [bearer: []]
      parameter name: :section_id, in: :path, type: :integer
      parameter name: :id, in: :path, type: :integer
      parameter name: :preview, in: :query, type: :string, required: false

      response 200, 'product found' do
        schema type: :object,
               properties: {
                 data: {
                   '$ref' => '#/components/schemas/product'
                 }
               }
        let(:section_id) { section.id }
        let(:id) { product.id }
        run_test!
      end

      response 200, 'product found prewiew' do
        let(:product) { create(:product, section: section, active: false) }
        let(:preview) { true }
        let(:section_id) { section.id }
        let(:id) { product.id }
        let(:Authorization) { authentication(user) }

        run_test!
      end

      response 404, 'product found prewiew other user' do
        let(:product) { create(:product, active: false) }
        let(:preview) { true }
        let(:section_id) { section.id }
        let(:id) { product.id }
        let(:Authorization) { authentication(user) }

        run_test!
      end

      response 404, 'product not found' do
        let(:section_id) { section.id }
        let(:id) { '0' }
        run_test!
      end

      response 404, 'product found active false' do
        let(:product) { create(:product, section: section, active: false) }
        let(:section_id) { section.id }
        let(:id) { product.id }
        run_test!
      end
    end
  end
end
