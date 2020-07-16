require 'rails_helper'

RSpec.describe 'Restaurants management', type: :request do
  let(:restaurant) { create(:restaurant) }
  let(:password) { Faker::Internet.password(min_length: 8, max_length: 12) }
  let(:email) { Faker::Internet.email }
  let(:restaurant_attrs) {
    {
      restaurant: {
        name: Faker::Name.name,
        email: email,
        password: password,
        password_confirmation: password
      }
    }
  }

  describe 'POST /v1/restaurants' do
    context 'when create success' do
      before { post '/v1/restaurants', params: restaurant_attrs }

      it { expect(response).to have_http_status(:created) }

      it 'response token' do
        expect(json_body['token']).to eq(Restaurant.find_by(email: email).authenticate_tokens.last.body)
      end
    end

    context 'when create fail' do
      before do
        restaurant_attrs[:restaurant][:email] = 'email'
        post '/v1/restaurants', params: restaurant_attrs
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'email is invalid' do
        expect(json_body['email']).to match_array([I18n.t('errors.messages.invalid_email_address')])
      end
    end
  end

  describe 'PUT /v1/restaurants/me' do
    context 'when restaurant update' do
      before do
        put '/v1/restaurants/me', params: restaurant_attrs.to_json,
                                  headers: header_with_authentication(restaurant)
      end

      it { expect(response).to have_http_status(:accepted) }
    end

    context 'when update fail' do
      before do
        restaurant_attrs[:restaurant][:email] = 'email'
        put '/v1/restaurants/me', params: restaurant_attrs.to_json,
                                  headers: header_with_authentication(restaurant)
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'email is invalid' do
        expect(json_body['email']).to match_array([I18n.t('errors.messages.invalid_email_address')])
      end
    end
  end

  describe 'GET /v1/restaurants/me' do
    context 'when Access allowed' do
      before do
        get '/v1/restaurants/me', headers: header_with_authentication(restaurant)
      end

      it { expect(response).to have_http_status(:ok) }
    end

    context 'when access denied ' do
      before do
        get '/v1/restaurants/me'
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
