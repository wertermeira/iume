require 'swagger_helper'

RSpec.describe 'v1/owners/feedbacks', swagger_doc: 'v1/swagger_owner.yaml', type: :request do
  TAG_NAME = 'Feedbacks'.freeze

  let(:user) { create(:owner) }
  let(:Authorization) { authentication(user) }
  let(:valid_attrs) {
    {
      feedback: {
        screen: 'screen',
        body: Faker::Lorem.question(word_count: 10, supplemental: false)
      }
    }
  }
  path '/v1/owners/feedbacks' do
    post 'create feedback' do
      tags TAG_NAME
      consumes 'application/json'
      produces 'application/json'
      security [bearer: []]
      parameter name: :feedback, in: :body, schema: {
        type: :object,
        properties: {
          feedback: {
            type: :object,
            properties: {
              screen: { type: :string, example: 'Home' },
              body: { type: :string, example: Faker::Lorem.question(word_count: 10, supplemental: false) }
            }
          }
        },
        required: %w[body]
      }

      response 201, 'created success' do
        schema type: :object,
               properties: {
                 id: { type: :string },
                 type: { type: :string, exemple: 'feedbacks' },
                 attributes: {
                   type: :object,
                   properties: {
                     screen: { type: :screen, example: 'home' },
                     body: { type: :string }
                   }
                 }
               }
        let(:feedback) { valid_attrs }

        run_test! do
          expect(json_body.dig('data', 'attributes', 'body')).to eq(valid_attrs[:feedback][:body])
        end
      end

      response 422, 'created success' do
        before { valid_attrs[:feedback][:body] = '' }

        schema type: :object,
               properties: {
                 body: {
                   type: :array,
                   items: { type: :string, example: I18n.t('errors.messages.blank') }
                 }
               }
        let(:feedback) { valid_attrs }

        run_test! do
          expect(json_body.dig('body')).to match_array([I18n.t('errors.messages.blank')])
        end
      end
    end
  end
end
