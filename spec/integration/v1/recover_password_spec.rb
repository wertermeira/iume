require 'swagger_helper'

RSpec.describe 'v1/owners', swagger_doc: 'v1/swagger_owner.yaml', type: :request do
  TAG_NAME = 'RecoverPassword'.freeze
  let(:user) { create(:owner) }

  path '/v1/recover_password/{model}' do
    let(:valid_attrs) {
      {
        recover: {
          email: user.email
        }
      }
    }

    post '' do
      let(:recover) { valid_attrs }
      let(:model) { 'owner' }

      tags TAG_NAME
      consumes 'application/json'
      produces 'application/json'
      parameter name: :model, in: :path, type: :string, example: :owner
      parameter name: :recover, in: :body, schema: {
        type: :object,
        properties: {
          recover: {
            type: :object,
            properties: {
              email: { type: :string, example: Faker::Internet.email }
            },
            required: %w[email]
          }
        }
      }

      response 201, 'send request update password' do
        schema type: :object,
               properties: {
                 message: {
                   type: :string, example: I18n.t('mailer.messages.check_your_mailbox')
                 }
               }
        run_test! do
          expect(json_body['message']).to eq(I18n.t('mailer.messages.check_your_mailbox'))
          expect(ActiveJob::Base.queue_adapter.enqueued_jobs.count).to eq(1)
        end
      end

      response 422, 'when model not found' do
        before do
          valid_attrs[:recover][:email] = Faker::Internet.email
        end
        schema type: :object,
               properties: {
                 errors: {
                   type: :object,
                   properties: {
                     email: { type: :string, example: I18n.t('errors.messages.email_not_found') }
                   }
                 }
               }
        run_test! do
          expect(json_body['errors']['email']).to eq(I18n.t('errors.messages.email_not_found'))
        end
      end

      response 404, 'not found model' do
        let(:model) { 'other' }
        run_test!
      end
    end
  end

  path '/v1/recover_password/{model}/{id}' do
    put 'when update password' do
      let(:Authorization) { authentication(user) }
      let(:new_password) { '123456789' }
      let(:model) { 'owner' }
      let(:id) { 'me' }
      let(:valid_attrs) {
        {
          recover: {
            password: new_password,
            password_confirmation: new_password
          }
        }
      }

      tags TAG_NAME
      consumes 'application/json'
      produces 'application/json'
      security [bearer: []]
      parameter name: :model, in: :path, type: :string, example: :owner
      parameter name: :id, in: :path, type: :string, example: :me
      parameter name: :recover, in: :body, schema: {
        type: :object,
        properties: {
          recover: {
            type: :object,
            properties: {
              password: { type: :string, example: '12345678' },
              password_con: { type: :string, example: '12345678' }
            },
            required: %w[password password_confirmation]
          }
        }
      }

      response 202, 'update success' do
        let(:recover) { valid_attrs }
        run_test! do
          expect(user.reload.authenticate(new_password)).to be_truthy
        end
      end
      response 422, 'update fail' do
        before { valid_attrs[:recover][:password] = 'xxxxxxxx' }
        let(:recover) { valid_attrs }
        schema type: :object,
               properties: {
                 password_confirmation: {
                   type: :array,
                   items: { type: :string, example: I18n.t('errors.messages.confirmation', attribute: 'Password') }
                 }
               }

        run_test! do
          expect(json_body['password_confirmation']).to eq([I18n.t('errors.messages.confirmation', attribute: 'Password')])
        end
      end
    end
  end
end
