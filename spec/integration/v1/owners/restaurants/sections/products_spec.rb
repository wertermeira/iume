require 'swagger_helper'

RSpec.describe 'v1/owners/restaurants/sections/{section_id}/products', type: :request, swagger_doc: 'v1/swagger_owner.yaml' do
  TAG_NAME = 'Products'.freeze
  let(:user) { create(:owner) }
  let(:product_count) { rand(1..10) }
  let(:Authorization) { authentication(user) }
  let(:restaurant) { create(:restaurant, owner: user) }
  let(:section) { create(:section, restaurant: restaurant) }
  let(:restaurant_id) { restaurant.uid }
  let(:name) { Faker::Name.name }
  let(:product_attrs) {
    {
      product: {
        name: name,
        active: true,
        price: '10.00',
        descrition: Faker::Lorem.paragraph_by_chars(number: 100, supplemental: false),
        image: {
          data: image_base_64
        }
      }
    }
  }

  path '/v1/owners/restaurants/sections/{section_id}/products' do
    get 'get all products of a section' do
      before { create_list(:product, product_count, section: section) }

      tags TAG_NAME
      produces 'application/json'
      security [bearer: []]
      parameter name: :section_id, in: :path, type: :string
      parameter name: :q, in: :query, required: false, schema: {
        type: :object,
        properties: {
          'q[s]': { type: :string, example: 'name+desc' }
        }
      }

      response 200, 'product array' do
        let(:section_id) { section.id }
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: {
                     '$ref' => '#/components/schemas/product'
                   }
                 }
               }

        run_test! do
          expect(json_body.dig('data').length).to eq(product_count)
        end
      end

      response 401, 'unauthorized' do
        let(:Authorization) { authentication(create(:owner)) }
      end
    end

    post 'create product' do
      tags TAG_NAME
      consumes 'application/json'
      produces 'application/json'
      security [bearer: []]
      parameter name: :section_id, in: :path, type: :string
      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          product: {
            type: :object,
            properties: {
              name: { type: :string, example: Faker::Company.name },
              description: { type: :string, example: Faker::Lorem.paragraph_by_chars(number: 100, supplemental: false) },
              image: {
                type: :object,
                properties: {
                  data: {
                    type: :string,
                    description: 'Only base64 date',
                    example: 'data:image/jpeg;base64,/9j/4RiDRXhpZgAATU0AKgA...'
                  }
                }
              },
              price: { type: :integer, example: '10.0' },
              active: { type: :boolean }
            },
            required: %w[name price active]
          }
        }
      }
      response 201, 'create success' do
        let(:section_id) { section.id }
        let(:product) { product_attrs }

        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/product' }
               }

        run_test! do
          expect(json_body.dig('data', 'attributes', 'name')).to eq(name)
        end
      end

      response 422, 'create fail' do
        before { product_attrs[:product][:name] = '' }
        let(:section_id) { section.id }
        let(:product) { product_attrs }

        schema type: :object,
               properties: {
                 name: { type: :array, items: { type: :string, example: I18n.t('errors.messages.blank') } }
               }

        run_test! do
          expect(json_body['name']).to match_array([I18n.t('errors.messages.blank')])
        end
      end
    end
  end

  path '/v1/owners/restaurants/sections/{section_id}/products/{id}' do
    let(:product_item) { create(:product, section: section) }

    get 'show product' do
      tags TAG_NAME
      produces 'application/json'
      security [bearer: []]
      parameter name: :section_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :integer

      response 200, 'product found' do
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/product' }
               }

        let(:section_id) { section.id }
        let(:id) { product_item.id }

        run_test!
      end

      response 401, 'Not autorization' do
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/product' }
               }

        let(:section_id) { section.id }
        let(:id) { create(:product).id }

        run_test!
      end
    end

    put 'update product' do
      tags TAG_NAME
      consumes 'application/json'
      produces 'application/json'
      security [bearer: []]
      description 'Use image_destroy only if you need delete image'
      parameter name: :section_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :string
      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          product: {
            type: :object,
            properties: {
              name: { type: :string, example: Faker::Company.name },
              description: { type: :string, example: Faker::Lorem.paragraph_by_chars(number: 100, supplemental: false) },
              image: {
                type: :object,
                properties: {
                  data: { type: :string, description: 'Only base64 date', example: 'data:image/jpeg;base64,/9j/4RiDRXhpZgAATU0AKgA...' }
                }
              },
              price: { type: :integer, example: '10.0' },
              active: { type: :boolean },
              image_destroy: { type: :boolean, description: 'If you need delete image' }
            },
            required: %w[name price active]
          }
        }
      }
      response 202, 'update success' do
        let(:section_id) { section.id }
        let(:product) { product_attrs }
        let(:id) { product_item.id }

        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/product' }
               }

        run_test! do
          expect(json_body.dig('data', 'attributes', 'name')).to eq(name)
        end
      end

      response 202, 'update remove image' do
        before {
          product_attrs[:product][:image_destroy] = true
        }
        let(:section_id) { section.id }
        let(:product) { product_attrs }
        let(:id) { product_item.id }

        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/product' }
               }

        run_test! do
          expect(json_body.dig('data', 'attributes', 'image')).to be_nil
        end
      end

      response 422, 'update fail' do
        before { product_attrs[:product][:name] = '' }

        let(:id) { product_item.id }
        let(:section_id) { section.id }
        let(:product) { product_attrs }

        schema type: :object,
               properties: {
                 name: { type: :array, items: { type: :string, example: I18n.t('errors.messages.blank') } }
               }

        run_test! do
          expect(json_body['name']).to match_array([I18n.t('errors.messages.blank')])
        end
      end
    end

    delete 'Delete product' do
      tags TAG_NAME
      security [bearer: []]
      produces 'application/json'
      parameter name: :section_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :integer

      response 204, 'destroy success' do
        let(:id) { product_item.id }
        let(:section_id) { section.id }

        run_test! do
          expect(user.products.find_by(id: product_item.id)).to be_nil
          expect(user.products.in_the_trash.find_by(id: product_item.id)).to be_truthy
        end
      end
    end
  end

  path '/v1/owners/restaurants/sections/{section_id}/products/sort' do
    put 'update sorts' do
      let(:products) { create_list(:product, 10, section: section) }
      let(:product_attrs) {
        {
          product: {
            ids: products.pluck(:id).reverse
          }
        }
      }
      tags TAG_NAME
      consumes 'application/json'
      produces 'application/json'
      description 'Owner can reorder position of products'
      security [bearer: []]
      parameter name: :section_id, in: :path, type: :string
      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          product: {
            type: :object,
            properties: {
              ids: { type: :array, example: [1, 2, 3, 4, 5] }
            },
            required: %w[ids]
          }
        }
      }

      response 202, 'update positions' do
        let(:product) { product_attrs }
        let(:section_id) { section.id }

        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: {
                     '$ref' => '#/components/schemas/product'
                   }
                 }
               }
        run_test! do
          expect(section.reload.products.sort_by_position.ids).to eq(products.pluck(:id).reverse)
        end
      end
    end
  end
end
