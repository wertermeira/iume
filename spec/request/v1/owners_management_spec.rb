require 'rails_helper'

RSpec.describe 'Owners management', type: :request do
  let(:owner) { create(:owner) }
  let(:password) { Faker::Internet.password(min_length: 8, max_length: 12) }
  let(:email) { Faker::Internet.email }
  let(:owner_attrs) {
    {
      owner: {
        name: Faker::Name.name,
        email: email,
        password: password,
        password_confirmation: password
      }
    }
  }

  describe 'POST /v1/owners' do
    context 'when create success' do
      before { post '/v1/owners', params: owner_attrs }

      it { expect(response).to have_http_status(:created) }

      it 'response token' do
        expect(json_body['token']).to eq(Owner.find_by(email: email).authenticate_tokens.last.body)
      end
    end

    context 'when create fail' do
      before do
        owner_attrs[:owner][:email] = 'email'
        post '/v1/owners', params: owner_attrs
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'email is invalid' do
        expect(json_body['email']).to match_array([I18n.t('errors.messages.invalid_email_address')])
      end
    end
  end

  describe 'PUT /v1/owners/me' do
    context 'when owner update' do
      before do
        put '/v1/owners/me', params: owner_attrs.to_json,
                             headers: header_with_authentication(owner)
      end

      it { expect(response).to have_http_status(:accepted) }
    end

    context 'when update fail' do
      before do
        owner_attrs[:owner][:email] = 'email'
        put '/v1/owners/me', params: owner_attrs.to_json,
                             headers: header_with_authentication(owner)
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'email is invalid' do
        expect(json_body['email']).to match_array([I18n.t('errors.messages.invalid_email_address')])
      end
    end
  end

  describe 'GET /v1/owners/me' do
    context 'when Access allowed' do
      before do
        get '/v1/owners/me', headers: header_with_authentication(owner)
      end

      it { expect(response).to have_http_status(:ok) }
    end

    context 'when access denied ' do
      before do
        get '/v1/owners/me'
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
