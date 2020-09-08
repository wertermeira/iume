require 'swagger_helper'

RSpec.describe 'v1/owners/restaurants', swagger_doc: 'v1/swagger_owner.yaml', type: :request do
  TAG_NAME = 'Restaurants'.freeze
  let(:user) { create(:owner) }
  let(:slug) { Faker::Internet.slug }
  let(:restaurant_item) { create(:restaurant, owner: user) }
  let(:Authorization) { authentication(user) }
  let(:valid_attrs) {
    {
      restaurant: {
        name: Faker::Company.name,
        active: true
      }
    }
  }

  path '/v1/owners/restaurants' do
    post 'Create' do
      tags TAG_NAME
      consumes 'application/json'
      produces 'application/json'
      security [bearer: []]
      parameter name: :restaurant, in: :body, schema: {
        type: :object,
        properties: {
          restaurant: {
            type: :object,
            properties: {
              name: { type: :string, example: Faker::Company.name },
              active: { type: :boolean }
            }
          }
        },
        required: %w[name active]
      }

      response 201, 'create restaurant' do
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/restaurant' }
               }
        let(:restaurant) { valid_attrs }

        run_test! do
          expect(json_body.dig('data', 'attributes', 'name')).to eq(valid_attrs[:restaurant][:name])
        end
      end

      response 422, 'create failt (limit)' do
        before {
          create(:restaurant, owner: user)
        }
        let(:restaurant) { valid_attrs }

        run_test!
      end

      response 422, 'create failt' do
        before {
          valid_attrs[:restaurant][:name] = ''
        }
        schema type: :object,
               properties: {
                 name: {
                   type: :array,
                   items: { type: :string, example: I18n.t('errors.messages.blank') }
                 }
               }
        let(:restaurant) { valid_attrs }

        run_test! do
          expect(json_body['name']).to match_array([I18n.t('errors.messages.blank')])
        end
      end
    end

    get 'All restaurants' do
      let(:restaurant_count) { rand(1..10) }
      before do
        create_list(:restaurant, restaurant_count, owner: user)
        create_list(:restaurant, restaurant_count)
      end
      tags TAG_NAME
      produces 'application/json'
      security [bearer: []]

      response 200, 'return array' do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: {
                     '$ref' => '#/components/schemas/restaurant'
                   }
                 }
               }

        run_test! do
          expect(json_body.dig('data').length).to eq(restaurant_count)
        end
      end
    end
  end

  path '/v1/owners/restaurants/{id}' do
    let(:restaurant) { valid_attrs }
    let(:id) { restaurant_item.uid }

    put 'update restaurant' do
      tags TAG_NAME
      consumes 'application/json'
      produces 'application/json'
      security [bearer: []]
      parameter name: :id, in: :path, type: :string
      parameter name: :restaurant, in: :body, schema: {
        type: :object,
        properties: {
          restaurant: {
            type: :object,
            properties: {
              name: { type: :string, example: Faker::Company.name },
              active: { type: :boolean }
            }
          }
        },
        required: %w[name active]
      }

      response 202, 'update success' do
        before {
          valid_attrs[:restaurant][:slug] = slug
        }
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/restaurant' }
               }

        run_test! do
          expect(json_body.dig('data', 'attributes', 'slug')).to eq(slug)
        end
      end

      response 422, 'create failt' do
        before {
          valid_attrs[:restaurant][:name] = ''
        }
        schema type: :object,
               properties: {
                 name: {
                   type: :array,
                   items: { type: :string, example: I18n.t('errors.messages.blank') }
                 }
               }

        run_test! do
          expect(json_body['name']).to match_array([I18n.t('errors.messages.blank')])
        end
      end
    end

    get 'show restaurant' do
      tags TAG_NAME
      produces 'application/json'
      security [bearer: []]
      parameter name: :id, in: :path, type: :string

      response 200, 'found' do
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/restaurant' }
               }
        run_test!
      end

      response 404, 'not found' do
        let(:id) { '0' }
        run_test!
      end
    end
  end

  path '/v1/owners/restaurants/availability_slug' do
    put 'check slug availability' do
      let(:valid_attrs) {
        {
          restaurant: {
            slug: slug
          }
        }
      }
      tags TAG_NAME
      consumes 'application/json'
      produces 'application/json'
      security [bearer: []]
      parameter name: :restaurant, in: :body, schema: {
        type: :object,
        properties: {
          restaurant: {
            type: :object,
            properties: {
              slug: { type: :string, example: Faker::Internet.slug }
            }
          }
        },
        required: %w[name active]
      }
      response 202, 'availability' do
        let(:restaurant) { valid_attrs }
        run_test!
      end

      response 422, 'availability' do
        schema type: :object,
               properties: {
                 slug: {
                   type: :array,
                   items: { type: :string, example: [I18n.t('errors.messages.taken')] }
                 }
               }
        before {
          create(:restaurant, slug: slug)
        }
        let(:restaurant) { valid_attrs }
        run_test! do
          expect(json_body.dig('slug')).to match_array([I18n.t('errors.messages.taken')])
        end
      end
    end
  end
end
