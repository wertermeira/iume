require 'swagger_helper'

RSpec.describe 'v1/owners/emails', swagger_doc: 'v1/swagger_owner.yaml', type: :request do
  TAG_NAME = 'Emails'.freeze
  let(:user) { create(:owner) }
  path '/v1/owners/emails' do
    get 'show email' do
      tags TAG_NAME
      produces 'application/json'
      parameter name: :email, in: :query, type: :string
      security [bearer: []]

      response 200, 'email found' do
        let(:Authorization) { authentication(user) }
        let(:email) { user.email }

        run_test!
      end

      response 404, 'email not found' do
        let(:Authorization) { authentication(user) }
        let(:email) { 'email@site.com' }

        run_test!
      end

      response 422, 'when email is blank' do
        schema type: :object,
               properties: {
                 email: {
                   type: :array,
                   items: { type: :string, example: I18n.t('errors.messages.blank') }
                 }
               }
        let(:Authorization) { authentication(user) }
        let(:email) { '' }

        run_test! do
          expect(json_body['email']).to match_array([I18n.t('errors.messages.blank')])
        end
      end
    end
  end
end
