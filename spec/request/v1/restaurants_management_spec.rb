require 'rails_helper'

RSpec.describe 'Restaurants management', type: :request do
  describe 'GET /v1/restaurants/{id}' do
    let(:restaurant) { create(:restaurant) }

    context 'when find restaurant' do
      before do
        get "/v1/restaurants/#{restaurant.slug}"
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(json_body.dig('data', 'id')).to eq(restaurant.uid) }
      it { expect(json_body.dig('data', 'attributes', 'slug')).to eq(restaurant.slug) }
    end

    context 'when find by_id restaurant' do
      before do
        get "/v1/restaurants/#{restaurant.uid}?by_id=true"
      end

      it { expect(response).to have_http_status(:ok) }
    end

    context 'when not found restaurant' do
      before do
        get '/v1/restaurants/0'
      end

      it { expect(response).to have_http_status(:not_found) }
    end
  end
end
