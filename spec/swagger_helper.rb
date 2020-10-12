# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API Iume Public',
        version: 'v1',
        description: 'Public endpoints'
      },
      paths: {},
      components: {
        schemas: {
          product: {
            type: :object,
            properties: {
              id: { type: :string, example: '1' },
              type: { type: :string, example: 'products' },
              attributes: {
                type: :object,
                properties: {
                  price: { type: :string, example: '10.0' },
                  name: { type: :string, example: Faker::Food.dish },
                  description: { type: :string, example: Faker::Restaurant.description, nullable: true },
                  position: { type: :integer, example: 0, nullable: true },
                  image: {
                    type: :object,
                    nullable: true,
                    properties: {
                      original: { type: :string, example: Faker::LoremFlickr.image },
                      small: { type: :string, example: Faker::LoremFlickr.image }
                    }
                  }
                },
                required: %w[price name]
              }
            }
          },
          section: {
            type: :object,
            properties: {
              id: { type: :string },
              type: { type: :string, example: 'sections' },
              attributes: {
                type: :object,
                properties: {
                  name: { type: :string, example: 'Drinks' },
                  description: { type: :string, example: 'Txt here' },
                  position: { type: :integer, example: 1 }
                }
              }
            }
          },
          phone: {
            type: :object,
            properties: {
              id: { type: :string, example: '1' },
              type: { type: :string, example: 'phones' },
              attributes: {
                type: :object,
                properties: {
                  number: { type: :string }
                }
              }
            }
          },
          restaurant: {
            type: :object,
            properties: {
              type: { type: :string, example: 'restaurants' },
              id: { type: :string },
              attributes: {
                type: :object,
                properties: {
                  name: { type: :string },
                  slug: { type: :string },
                  active: { type: :boolean },
                  image: {
                    type: :object,
                    nullable: true,
                    properties: {
                      original: { type: :string, example: Faker::LoremFlickr.image },
                      small: { type: :string, example: Faker::LoremFlickr.image }
                    }
                  }
                },
                required: %w[name slug active]
              },
              relationships: {
                type: :object,
                properties: {
                  sections: {
                    type: :object,
                    properties: {
                      data: {
                        type: :array,
                        items: {
                          type: :object
                        },
                        example: [{ id: '1', type: 'sections' }, { id: '1', type: 'phones' }, { id: '1', type: 'tool_whatsapps' }]
                      }
                    }
                  }
                }
              }
            }
          }
        },
        securitySchemes: {
          bearer: {
            type: :http,
            scheme: :bearer
          }
        }
      },
      servers: [
        {
          url: ENV.fetch('APP_URL') { 'http://localhost:3000' },
          variables: {
            defaultHost: {
              default: ENV.fetch('APP_URL') { 'http://localhost:3000' }
            }
          }
        },
        {
          url: 'https://imenu-dev.herokuapp.com',
          variables: {
            defaultHost: {
              default: 'https://imenu-dev.herokuapp.com'
            }
          }
        }
      ]
    },
    'v1/swagger_owner.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API Iume Owner',
        version: 'v1',
        description: 'Owner endpoints'
      },
      paths: {},
      components: {
        schemas: {
          tools_whatsapp: {
            type: :object,
            properties: {
              data: {
                type: :object,
                properties: {
                  type: { type: :string, example: 'tool_whatsapps' },
                  attributes: {
                    type: :object,
                    properties: {
                      active: { type: :boolean },
                      created_at: { type: :datetime, example: Time.now },
                      updated_at: { type: :datetime, example: Time.now }
                    }
                  },
                  relationships: {
                    type: :object,
                    properties: {
                      phones: {
                        type: :object,
                        properties: {
                          data: {
                            type: :array,
                            items: {
                              type: :object
                            },
                            example: [{ id: '1', type: 'phones' }]
                          }
                        }
                      }
                    }
                  }
                }
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
                    },
                    relationships: {
                      data: {
                        restaurants: {
                          data: { id: '1', type: 'restaurants' }
                        }
                      }
                    }
                  },
                  {
                    id: '1',
                    type: 'restaurants',
                    attributes: {
                      name: Faker::Company.name,
                      slug: Faker::Internet.slug
                    }
                  }
                ]
              }
            }
          },
          phone: {
            type: :object,
            properties: {
              id: { type: :string, example: '1' },
              type: { type: :string, example: 'phones' },
              attributes: {
                type: :object,
                properties: {
                  number: { type: :string }
                }
              }
            }
          },
          owner: {
            type: :object,
            properties: {
              id: { type: :string, example: '1' },
              type: { type: :string, example: 'owners' },
              attributes: {
                type: :object,
                properties: {
                  email: { type: :string, example: Faker::Internet.email },
                  name: { type: :string, nullable: true },
                  login_count: { type: :integer, example: 1 },
                  created_at: { type: :string, example: Time.now },
                  updated_at: { type: :string, example: Time.now }
                },
                required: %w[email login_count]
              }
            }
          },
          product: {
            type: :object,
            properties: {
              id: { type: :string, example: '1' },
              type: { type: :string, example: 'products' },
              attributes: {
                type: :object,
                properties: {
                  price: { type: :string, example: '10.0' },
                  name: { type: :string, example: Faker::Food.dish },
                  description: { type: :string, example: Faker::Restaurant.description, nullable: true },
                  position: { type: :integer, example: 0, nullable: true },
                  active: { type: :boolean },
                  image: {
                    type: :object,
                    nullable: true,
                    properties: {
                      original: { type: :string, example: Faker::LoremFlickr.image },
                      small: { type: :string, example: Faker::LoremFlickr.image }
                    }
                  }
                },
                required: %w[price name]
              }
            }
          },
          section: {
            type: :object,
            properties: {
              id: { type: :string },
              type: { type: :string, example: 'sections' },
              attributes: {
                type: :object,
                properties: {
                  name: { type: :string, example: 'Drinks' },
                  description: { type: :string, example: 'Txt here' },
                  position: { type: :integer, example: 1 },
                  active: { type: :boolean }
                }
              }
            }
          },
          restaurant: {
            type: :object,
            properties: {
              type: { type: :string, example: 'restaurants' },
              id: { type: :string },
              attributes: {
                type: :object,
                properties: {
                  name: { type: :string },
                  slug: { type: :string },
                  products_remaining: { type: :integer, example: 1 },
                  active: { type: :boolean }
                },
                required: %w[name slug active]
              },
              relationships: {
                type: :object,
                properties: {
                  sections: {
                    type: :object,
                    properties: {
                      data: {
                        type: :array,
                        items: {
                          properties: {
                            id: { type: :string },
                            type: { type: :string, example: 'phones' }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        },
        securitySchemes: {
          bearer: {
            type: :http,
            scheme: :bearer
          }
        }
      },
      servers: [
        {
          url: ENV.fetch('APP_URL') { 'http://localhost:3000' },
          variables: {
            defaultHost: {
              default: ENV.fetch('APP_URL') { 'http://localhost:3000' }
            }
          }
        },
        {
          url: 'https://imenu-dev.herokuapp.com',
          variables: {
            defaultHost: {
              default: 'https://imenu-dev.herokuapp.com'
            }
          }
        },
        {
          url: 'https://iume-api-stage.herokuapp.com',
          variables: {
            defaultHost: {
              default: 'https://iume-api-stage.herokuapp.com'
            }
          }
        }
      ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end
