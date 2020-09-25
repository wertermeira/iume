require 'swagger_helper'

RSpec.describe 'v1/restaurants/{restaurant_id}/orders', type: :request do
  let(:restaurant) { create(:restaurant) }
  let(:section) { create(:section, restaurant: restaurant) }
  let(:product) { create(:product, section: section) }

  path '/v1/restaurants/{restaurant_id}/orders' do
    let(:product_count) { rand(1..10) }
    let(:products) { create_list(:product, product_count, section_id: section.id) }
    before do
      create(:address, addressable: restaurant)
      create(:tool_whatsapp, restaurant: restaurant, active: true)
    end
    post 'Create order' do
      let(:order_attributes) {
        {
          order: {
            order_details_attributes: products.map { |prod| { product_id: prod.id, quantity: rand(1..10) } }
          }
        }
      }
      tags 'Restaurants/Orders'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :restaurant_id, in: :path, type: :integer
      parameter name: :order, in: :body, schema: {
        type: :object,
        properties: {
          order: {
            type: :object,
            properties: {
              order_details_attributes: {
                type: :array,
                items: {
                  type: :object
                },
                example: [{ product_id: 1, quantity: 1 }, { product_id: 2, quantity: 3 }]
              }
            },
            required: %w[product_id quantity]
          }
        },
        required: %w[order_details_attributes]
      }

      response 201, 'created order' do
        let(:restaurant_id) { restaurant.uid }
        let(:order) { order_attributes }
        run_test! do
          expect(Order.last.order_details.count).to eq(product_count)
        end
      end

      response 422, 'create fail order without order_details' do
        let(:order_attributes) {
          {
            order: {
              order_details_attributes: ''
            }
          }
        }
        let(:restaurant_id) { create(:restaurant).uid }
        let(:order) { order_attributes }
        run_test! do
          expect(json_body.dig('order_details')).to match_array([I18n.t('errors.messages.blank')])
        end
      end

      response 422, 'create fail order invalid product' do
        let(:order_attributes) {
          {
            order: {
              order_details_attributes: products.map { |prod| { product_id: prod.id, quantity: rand(1..10) } }
            }
          }
        }
        let(:restaurant_id) { create(:restaurant).uid }
        let(:order) { order_attributes }
        run_test! do
          expect(json_body.dig('order_details.product_id')).to match_array([I18n.t('errors.messages.invalid')])
        end
      end
    end
  end
end
