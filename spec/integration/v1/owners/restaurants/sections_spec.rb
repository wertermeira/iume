require 'swagger_helper'

RSpec.describe 'v1/owners/restaurants/{restaurant_id}/sections', type: :request, swagger_doc: 'v1/swagger_owner.yaml' do
  TAG_NAME = 'Sections'.freeze
  let(:user) { create(:owner) }
  let(:section_count) { rand(1..10) }
  let(:Authorization) { authentication(user) }
  let(:restaurant) { create(:restaurant, owner: user) }
  let(:restaurant_id) { restaurant.uid }
  let(:name) { Faker::Name.name }
  let(:section_attrs) {
    {
      section: {
        name: name,
        active: true,
        description: 'Txt here',
        position: 1
      }
    }
  }

  path '/v1/owners/restaurants/{restaurant_id}/sections' do
    get 'get all sections of a restaurant' do
      before { create_list(:section, section_count, restaurant: restaurant) }

      tags TAG_NAME
      produces 'application/json'
      security [bearer: []]
      parameter name: :restaurant_id, in: :path, type: :string

      response 200, 'sections array' do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: {
                     '$ref' => '#/components/schemas/section'
                   }
                 }
               }

        run_test! do
          expect(json_body.dig('data').length).to eq(section_count)
        end
      end

      response 401, 'unauthorized' do
        let(:Authorization) { authentication(create(:owner)) }
      end
    end

    post 'create section' do
      tags TAG_NAME
      consumes 'application/json'
      produces 'application/json'
      security [bearer: []]
      parameter name: :restaurant_id, in: :path, type: :string
      parameter name: :section, in: :body, schema: {
        type: :object,
        properties: {
          section: {
            type: :object,
            properties: {
              name: { type: :string, example: Faker::Company.name },
              position: { type: :integer, example: 1 },
              description: { type: :string, example: 'txt here' },
              active: { type: :boolean }
            }
          }
        },
        required: %w[name active]
      }
      response 201, 'create success' do
        let(:section) { section_attrs }

        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/section' }
               }

        run_test! do
          expect(json_body.dig('data', 'attributes', 'name')).to eq(name)
        end
      end

      response 422, 'create fail' do
        before { section_attrs[:section][:name] = '' }
        let(:section) { section_attrs }

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

  path '/v1/owners/restaurants/{restaurant_id}/sections/{id}' do
    let(:section_item) { create(:section, restaurant: restaurant) }

    get 'show section' do
      tags TAG_NAME
      produces 'application/json'
      security [bearer: []]
      parameter name: :restaurant_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :integer

      response 200, 'section found' do
        let(:section) { create(:section, restaurant: restaurant) }
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/section' }
               }

        let(:id) { section.id }
        run_test!
      end

      response 404, 'section not found' do
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/section' }
               }

        let(:id) { create(:section).id }
        run_test!
      end
    end

    put 'update section' do
      tags TAG_NAME
      consumes 'application/json'
      produces 'application/json'
      security [bearer: []]
      parameter name: :restaurant_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :integer
      parameter name: :section, in: :body, schema: {
        type: :object,
        properties: {
          section: {
            type: :object,
            properties: {
              name: { type: :string, example: Faker::Company.name },
              position: { type: :integer, example: 1 },
              description: { type: :string, example: 'txt here' },
              active: { type: :boolean }
            }
          }
        },
        required: %w[name active]
      }
      response 202, 'update success' do
        let(:id) { section_item.id }
        let(:section) { section_attrs }

        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/section' }
               }

        run_test! do
          expect(json_body.dig('data', 'attributes', 'name')).to eq(name)
        end
      end

      response 422, 'update fail' do
        before { section_attrs[:section][:name] = '' }

        let(:id) { section_item.id }
        let(:section) { section_attrs }

        schema type: :object,
               properties: {
                 name: { type: :array, items: { type: :string, example: I18n.t('errors.messages.blank') } }
               }

        run_test! do
          expect(json_body['name']).to match_array([I18n.t('errors.messages.blank')])
        end
      end
    end

    delete 'Delete section' do
      tags TAG_NAME
      security [bearer: []]
      produces 'application/json'
      parameter name: :restaurant_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :integer

      response 204, 'destroy success' do
        let(:id) { section_item.id }
        run_test! do
          expect(user.sections.find_by(id: section_item.id)).to be_nil
        end
      end
    end
  end

  path '/v1/owners/restaurants/{restaurant_id}/sections/sort' do
    put 'update sorts' do
      let(:sections) { create_list(:section, 10, restaurant: restaurant) }
      let(:section_attrs) {
        {
          section: {
            ids: sections.pluck(:id).reverse
          }
        }
      }
      tags TAG_NAME
      consumes 'application/json'
      produces 'application/json'
      description 'Owner can reorder position of sections'
      security [bearer: []]
      parameter name: :restaurant_id, in: :path, type: :string
      parameter name: :section, in: :body, schema: {
        type: :object,
        properties: {
          section: {
            type: :object,
            properties: {
              ids: { type: :array, example: [1, 2, 3, 4, 5] }
            }
          }
        },
        required: %w[ids]
      }

      response 202, 'update positions' do
        let(:section) { section_attrs }

        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: {
                     '$ref' => '#/components/schemas/section'
                   }
                 }
               }
        run_test! do
          expect(restaurant.reload.sections.sort_by_position.ids).to eq(sections.pluck(:id).reverse)
        end
      end
    end
  end
end
