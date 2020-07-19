require 'rails_helper'

RSpec.describe 'Sessions Managements', type: :request do
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

  describe 'POST /v1/owners/sessions' do
    context 'when login success' do
      before { post '/v1/owners/sessions', params: login_attrs }

      it { expect(response).to have_http_status(:created) }

      it 'response token' do
        expect(json_body['token']).to eq(owner.authenticate_tokens.last.body)
      end
    end

    context 'when login email not found' do
      before do
        login_attrs[:login][:email] = 'xxxx@site.com'
        post '/v1/owners/sessions', params: login_attrs
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it { expect(json_body['email']).to match_array([I18n.t('errors.messages.email_not_found')]) }
    end

    context 'when login password is wrong' do
      before do
        login_attrs[:login][:password] = 'xxx2xxx'
        post '/v1/owners/sessions', params: login_attrs
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it { expect(json_body['password']).to match_array([I18n.t('errors.messages.login.invalid_password')]) }
    end
  end

  describe 'DELETE /v1/owners/sessions' do
    context 'when destroy token' do
      before { delete '/v1/owners/sessions/me', headers: header_with_authentication(owner) }

      it { expect(response).to have_http_status(:no_content) }
    end

    context 'when owner is not logged in' do
      before { delete '/v1/owners/sessions/me' }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(json_body.dig('errors', 'message')).to eq('Access denied') }
      it { expect(json_body.dig('errors', 'status').to_i).to eq(401) }
    end
  end
end
