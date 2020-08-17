require 'swagger_helper'

RSpec.describe 'v1/owners',  swagger_doc: 'v1/swagger_owner.yaml', type: :request do
  let(:user) { create(:owner) }
  let(:password) { Faker::Internet.password(min_length: 8, max_length: 12) }
  let(:email) { Faker::Internet.email }
  let(:owner_valid) {
    {
      owner: {
        name: Faker::Name.name,
        email: email,
        password: password,
        password_confirmation: password
      }
    }
  }

  path '/v1/owners' do
    post 'Creates a owner' do
      tags 'Owners'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :owner, in: :body, schema: {
        type: :object,
        properties: {
          owner: {
            type: :object,
            properties: {
              email: { type: :string, example: Faker::Internet.email },
              password: { type: :string, example: '12345678' },
              password_confirmation: { type: :string, example: '12345678' }
            }
          }
        },
        required: %w[email password password_confirmation]
      }
  
      response 201, 'owner created' do
        schema type: :object,
          properties: {
            token: { type: :string, example: 'xxxxx' }
          },
          required: %w[token]

        let(:owner) { owner_valid }

        run_test! do |response|
          expect(json_body['token']).to eq(Owner.find_by(email: email).authenticate_tokens.last.body)
        end
      end

      response 422, 'owner created fail' do
        schema type: :object,
          properties: {
            email: {
              type: :array,
              items: { type: :string, example: I18n.t('errors.messages.invalid_email_address') }
            }
          }
        let(:owner) { owner_valid }

        before { owner_valid[:owner][:email] = 'email' }

        run_test! do |response|
          expect(json_body['email']).to match_array([I18n.t('errors.messages.invalid_email_address')])
        end
      end
    end
  end

  path '/v1/owners/me' do
    get 'Show me' do
      tags 'Owners'
      security [ bearer: [] ]
      produces 'application/json'

      response 200, 'get me' do
        schema type: :object,
          properties: {
            data: { '$ref' => '#/components/schemas/owner' }
          }
        let(:Authorization) { authentication(user) }
        run_test!
      end
    end

    put 'Update me' do
      tags 'Owners'
      consumes 'application/json'
      produces 'application/json'
      security [ bearer: [] ]
      parameter name: :owner, in: :body, schema: {
        type: :object,
        properties: {
          owner: {
            type: :object,
            properties: {
              email: { type: :string, example: Faker::Internet.email },
              password: { type: :string, example: '12345678' },
              password_confirmation: { type: :string, example: '12345678' }
            }
          }
        },
        required: %w[email password password_confirmation]
      }

      response 202, 'get me' do
        schema type: :object,
          properties: {
            data: { '$ref' => '#/components/schemas/owner' }
          }
        let(:Authorization) { authentication(user) }
        let(:owner) { owner_valid }
        run_test!
      end

      response 422, 'owner update fail' do
        schema type: :object,
          properties: {
            email: {
              type: :array,
              items: { type: :string, example: I18n.t('errors.messages.invalid_email_address') }
            }
          }
        let(:Authorization) { authentication(user) }
        let(:owner) { owner_valid }

        before { owner_valid[:owner][:email] = 'email' }

        run_test! do |response|
          expect(json_body['email']).to match_array([I18n.t('errors.messages.invalid_email_address')])
        end
      end
    end

    delete 'Delete me' do
      tags 'Owners'
      security [ bearer: [] ]
      produces 'application/json'

      response 204, 'get me' do
        let(:Authorization) { authentication(user) }
        run_test! do
          expect(Owner.find_by(id: user.id)).to be_nil 
        end
      end
    end
  end
end