require 'swagger_helper'

RSpec.describe 'v1/owners', swagger_doc: 'v1/swagger_owner.yaml', type: :request do
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

        run_test! do
          expect(json_body['token']).to eq(Owner.find_by(email: email).authenticate_tokens.last.body)
          expect(ActiveJob::Base.queue_adapter.enqueued_jobs.count).to eq(1)
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

        run_test! do
          expect(json_body['email']).to match_array([I18n.t('errors.messages.invalid_email_address')])
        end
      end
    end
  end

  path '/v1/owners/me' do
    get 'Show me' do
      tags 'Owners'
      security [bearer: []]
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
      let(:new_password) { Faker::Internet.password(min_length: 8, max_length: 12) }
      let(:user) { create(:owner, password: password, password_confirmation: password, email: email) }
      let(:owner_valid) {
        {
          owner: {
            name: Faker::Name.name,
            email: email
          }
        }
      }
      tags 'Owners'
      consumes 'application/json'
      produces 'application/json'
      security [bearer: []]
      description 'to update email or password the current password is required ... use the password_current field'
      parameter name: :owner, in: :body, schema: {
        type: :object,
        properties: {
          owner: {
            type: :object,
            properties: {
              email: { type: :string, example: Faker::Internet.email },
              password: { type: :string, example: '12345678' },
              password_confirmation: { type: :string, example: '12345678' },
              password_current: { type: :string, example: '12345678', description: 'Only needed to update sensitive data' }
            },
            required: %w[email]
          }
        }
      }

      response 202, 'update' do
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/owner' }
               }

        let(:Authorization) { authentication(user) }
        let(:owner) { owner_valid }
        run_test!
      end

      response 202, 'update password' do
        let(:owner_valid) {
          {
            owner: {
              name: Faker::Name.name,
              email: email,
              password: new_password,
              password_confirmation: new_password,
              password_current: password
            }
          }
        }
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/owner' }
               }

        let(:Authorization) { authentication(user) }
        let(:owner) { owner_valid }

        run_test! do
          expect(user.reload.authenticate(new_password)).to be_truthy
          expect(user.reload.authenticate(password)).to be_falsey
        end
      end

      response 202, 'update email' do
        let(:new_email) { Faker::Internet.email }
        let(:owner_valid) {
          {
            owner: {
              name: Faker::Name.name,
              email: new_email,
              password_current: password
            }
          }
        }
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/owner' }
               }

        let(:Authorization) { authentication(user) }
        let(:owner) { owner_valid }

        run_test! do
          expect(json_body.dig('data', 'attributes', 'email')).to eq(new_email)
        end
      end

      response 422, 'update password current invalid' do
        let(:owner_valid) {
          {
            owner: {
              name: Faker::Name.name,
              email: email,
              password: new_password,
              password_confirmation: new_password,
              password_current: 'x2xxxxxx'
            }
          }
        }

        let(:Authorization) { authentication(user) }
        let(:owner) { owner_valid }
        run_test! do
          expect(json_body['password_current']).to match_array([I18n.t('errors.messages.login.invalid_password')])
        end
      end

      response 422, 'update try update email' do
        let(:owner_valid) {
          {
            owner: {
              name: Faker::Name.name,
              email: 'new@email.com'
            }
          }
        }

        let(:Authorization) { authentication(user) }
        let(:owner) { owner_valid }
        run_test! do
          expect(json_body['password_current']).to match_array([I18n.t('errors.messages.blank')])
        end
      end

      response 422, 'owner update fail' do
        schema type: :object,
               properties: {
                 email: {
                   type: :array,
                   items: { type: :string, example: I18n.t('errors.messages.blank') }
                 }
               }

        let(:Authorization) { authentication(user) }
        let(:owner) { owner_valid }

        before { owner_valid[:owner][:email] = '' }

        run_test! do
          expect(json_body['email']).to match_array([I18n.t('errors.messages.blank')])
        end
      end
    end

    delete 'Delete me' do
      tags 'Owners'
      security [bearer: []]
      produces 'application/json'

      response 204, 'destroy success' do
        let(:Authorization) { authentication(user) }
        run_test! do
          expect(Owner.find_by(id: user.id)).to be_nil
        end
      end
    end
  end
end
