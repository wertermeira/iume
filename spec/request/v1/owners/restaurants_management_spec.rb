require 'rails_helper'

RSpec.describe 'Restaurants management', type: :request do
  let(:owner) { create(:owner) }
  let(:restaurant_attrs) {
    {
      restaurant: {
        name: Faker::Company.name
      }
    }
  }

  describe 'GET /v1/owners/restaurants' do
    let(:restaurant_count) { rand(1..10) }

    context 'when count restaurants' do
      before do
        create_list(:restaurant, restaurant_count, owner: owner)
        create_list(:restaurant, restaurant_count)
        get '/v1/owners/restaurants', headers: header_with_authentication(owner)
      end
      it { expect(response).to have_http_status(:ok) }

      it { expect(json_body.dig('data').length).to eq(restaurant_count) }
    end
  end

  describe 'POST /v1/owners/restaurants' do
    context 'when create success' do
      before { post '/v1/owners/restaurants', params: restaurant_attrs.to_json, headers: header_with_authentication(owner) }

      it { expect(response).to have_http_status(:created) }
    end

    context 'when create failt (limit)' do
      before do
        create(:restaurant, owner: owner)
        post '/v1/owners/restaurants', params: restaurant_attrs.to_json, headers: header_with_authentication(owner)
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end

    context 'when create fail' do
      before do
        restaurant_attrs[:restaurant][:name] = ''
        post '/v1/owners/restaurants', params: restaurant_attrs.to_json, headers: header_with_authentication(owner)
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it { expect(json_body['name']).to match_array([I18n.t('errors.messages.blank')]) }
    end
  end

  describe 'PUT /v1/owners/restaurants/{id}' do
    let(:restaurant) { create(:restaurant, owner: owner) }
    let(:slug) { Faker::Internet.slug }

    context 'when owner update' do
      before do
        restaurant_attrs[:restaurant][:slug] = slug
        put "/v1/owners/restaurants/#{restaurant.id}", params: restaurant_attrs.to_json,
                                                       headers: header_with_authentication(owner)
      end

      it { expect(response).to have_http_status(:accepted) }

      it { expect(json_body.dig('data', 'attributes', 'slug')).to eq(slug) }
    end

    context 'when update fail' do
      before do
        restaurant_attrs[:restaurant][:slug] = ''
        put "/v1/owners/restaurants/#{restaurant.id}", params: restaurant_attrs.to_json,
                                                       headers: header_with_authentication(owner)
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it { expect(json_body['slug']).to match_array([I18n.t('errors.messages.blank')]) }
    end
  end

  describe 'GET /v1/owners/restaurants/{id}' do
    let(:restaurant) { create(:restaurant, owner: owner) }

    context 'when find restaurant' do
      before do
        get "/v1/owners/restaurants/#{restaurant.id}", headers: header_with_authentication(owner)
      end

      it { expect(response).to have_http_status(:ok) }

      it { expect(json_body.dig('data', 'attributes', 'slug')).to eq(restaurant.slug) }
    end

    context 'when not found restaurant' do
      before do
        get '/v1/owners/restaurants/0', headers: header_with_authentication(owner)
      end

      it { expect(response).to have_http_status(:not_found) }
    end

    context 'when restaurant other owner (not found)' do
      before do
        get "/v1/owners/restaurants/#{restaurant.id}", headers: header_with_authentication(create(:owner))
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
