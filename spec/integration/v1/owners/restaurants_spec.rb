require 'swagger_helper'

RSpec.describe 'v1/owners/restaurants', swagger_doc: 'v1/swagger_owner.yaml', type: :request do
  TAG_NAME = 'Restaurants'.freeze
  let(:user) { create(:owner) }
  let(:slug) { Faker::Internet.slug }
  let(:restaurant_item) { create(:restaurant, owner: user) }
  let(:Authorization) { authentication(user) }
  let(:phones_attributes) {
    [
      {
        number: '11-9999-9999'
      },
      {
        number: '11-9999-9999'
      }
    ]
  }
  let(:address_attributes) {
    {
      street: Faker::Address.street_name,
      neighborhood: Faker::Address.street_name,
      complement: Faker::Address.community,
      number: Faker::Address.building_number,
      reference: Faker::Address.city_prefix,
      cep: '44900-000'
    }
  }
  let(:valid_attrs) {
    {
      restaurant: {
        name: Faker::Company.name,
        active: true,
        image: {
          data: image_base_64
        }
      }
    }
  }
  let(:included) { 'phones,address,address.city,address.city.state' }

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
          expect(json_body.dig('data', 'attributes', 'image')).not_to be_nil
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
      parameter name: :included, in: :query, type: :string, required: false,
                example: 'phones,address,address.city,address.city.state'

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
    let(:city) { create(:city) }
    let(:correios) { instance_double(Correios::CEP::AddressFinder) }
    let(:correios_reponse) {
      {
        neighborhood: '', zipcode: '44900000', city: city.name,
        address: '', state: city.state.acronym, complement: ''
      }
    }

    before do
      allow(Correios::CEP::AddressFinder).to receive(:new).and_return(correios)
      allow(correios).to receive(:get).and_return(correios_reponse)
    end

    put 'update restaurant' do
      tags TAG_NAME
      consumes 'application/json'
      produces 'application/json'
      security [bearer: []]
      description 'Use image_destroy only if you need delete image'
      parameter name: :id, in: :path, type: :string
      parameter name: :restaurant, in: :body, schema: {
        type: :object,
        properties: {
          restaurant: {
            type: :object,
            properties: {
              name: { type: :string, example: Faker::Company.name },
              active: { type: :boolean },
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
              image_destroy: { type: :boolean, description: 'If you need delete image' },
              phones_attributes: {
                type: :array,
                items: {
                  type: :object
                },
                example: [{ number: '11-9999-9999' }, { id: 1, number: '11-9999-9999' }, { id: 2, _destroy: true }]
              },
              address_attributes: {
                type: :object,
                properties: {
                  street: { type: :string, example: Faker::Address.street_name },
                  neighborhood: { type: :string, example: 'Center' },
                  complement: { type: :string, example: Faker::Address.community },
                  number: { type: :string, example: Faker::Address.building_number },
                  reference: { type: :string },
                  cep: { type: :string, example: '44900-000' }
                },
                required: %w[street cep neighborhood]
              }
            }
          }
        },
        required: %w[name active]
      }

      response 202, 'update remove image' do
        let(:restaurant) {
          {
            restaurant: {
              image_destroy: true
            }
          }
        }

        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/restaurant' }
               }

        run_test! do
          expect(json_body.dig('data', 'attributes', 'image')).to be_nil
        end
      end

      response 202, 'update success only phones' do
        let(:restaurant) {
          {
            restaurant: {
              phones_attributes: phones_attributes
            }
          }
        }

        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/restaurant' },
                 included: {
                   type: :array,
                   items: { '$ref' => '#/components/schemas/phone' }
                 }
               }

        run_test!
      end

      response 202, 'update success only address' do
        before do
          create(:address, addressable: restaurant_item)
        end

        let(:restaurant) {
          {
            restaurant: {
              address_attributes: address_attributes
            }
          }
        }

        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/restaurant' },
                 included: {
                   type: :array,
                   items: { '$ref' => '#/components/schemas/phone' }
                 }
               }

        run_test! do
          expect(restaurant_item.address.street).to eq(address_attributes[:street])
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

      response 202, 'update success' do
        before {
          valid_attrs[:restaurant][:slug] = slug
          valid_attrs[:restaurant][:phones_attributes] = phones_attributes
          valid_attrs[:restaurant][:address_attributes] = address_attributes
        }
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/restaurant' },
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

        run_test! do
          expect(json_body.dig('data', 'attributes', 'slug')).to eq(slug)
          expect(json_body.dig('data', 'relationships', 'address', 'data')).to be_truthy
        end
      end
    end

    get 'show restaurant' do
      tags TAG_NAME
      produces 'application/json'
      security [bearer: []]
      parameter name: :id, in: :path, type: :string
      parameter name: :included, in: :query, type: :string, required: false,
                example: 'phones,address,address.city,address.city.state'

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
