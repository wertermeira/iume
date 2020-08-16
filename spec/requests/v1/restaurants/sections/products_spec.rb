require 'swagger_helper'

RSpec.describe 'v1/restaurants/sections/{section_id}/products', type: :request do
  let(:restaurant) { create(:restaurant) }
  let(:section) { create(:section, restaurant: restaurant) }
  let(:product) { create(:product, section: section) }

  path '/v1/restaurants/sections/{section_id}/products' do
    before { create_list(:product, 10, section_id: section.id) }

    get 'All products of a section' do
      tags 'Products'
      produces 'application/json'
      parameter name: :section_id, in: :path, type: :integer

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
        run_test!
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
      parameter name: :section_id, in: :path, type: :integer
      parameter name: :id, in: :path, type: :integer

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

      response 404, 'product not found' do
        let(:section_id) { section.id }
        let(:id) { '0' }
        run_test!
      end
    end
  end
end
