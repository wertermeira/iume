require 'swagger_helper'

RSpec.describe 'v1/owners/sessions', swagger_doc: 'v1/swagger_owner.yaml', type: :request do
  TAG_NAME = 'Sessions'.freeze

  path '/v1/owners/sessions' do
    let(:password) { Faker::Internet.password(min_length: 8, max_length: 12) }
    let(:owner) { create(:owner, password: password) }
    let(:login_attrs) {
      {
        login: {
          email: owner.email,
          password: password
        }
      }
    }
    post 'Login' do
      tags TAG_NAME
      consumes 'application/json'
      produces 'application/json'
      parameter name: :login, in: :body, schema: {
        type: :object,
        properties: {
          login: {
            type: :object,
            properties: {
              email: { type: :string, example: Faker::Internet.email },
              password: { type: :string, example: '12345678' }
            }
          }
        },
        required: %w[email password]
      }
      response 201, 'login success' do
        schema type: :object,
               properties: {
                 token: { type: :string, example: 'xxxxx' }
               },
               required: %w[token]

        let(:login) { login_attrs }
        run_test!
      end

      response 422, 'login fail' do
        before { login_attrs[:login][:password] = '123456' }
        schema type: :object,
               properties: {
                 password: {
                   type: :array,
                   items: { type: :string, example: I18n.t('errors.messages.login.invalid_password') }
                 }
               }

        let(:login) { login_attrs }
        run_test! do
          expect(json_body['password']).to match_array([I18n.t('errors.messages.login.invalid_password')])
        end
      end
    end
  end

  path '/v1/owners/sessions/me' do
    let(:user) { create(:owner) }
    delete 'Destroy session' do
      tags TAG_NAME
      consumes 'application/json'
      produces 'application/json'
      security [bearer: []]

      response 204, 'login success' do
        let(:Authorization) { authentication(user) }
        run_test!
      end

      response 401, 'when owner is not logged in' do
        let(:Authorization) { '' }
        run_test!
      end
    end
  end
end
