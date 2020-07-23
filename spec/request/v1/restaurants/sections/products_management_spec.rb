require 'rails_helper'

RSpec.describe 'Product management', type: :request do

  describe 'GET /v1/restaurants/sections/{section_id}/products' do
    let(:product_count) { rand(1..10) }

    context 'when count products' do
      let(:section) { create(:section, active: true) }

      before do
        create_list(:product, product_count, section: section)
        create_list(:product, product_count)
        get "/v1/restaurants/sections/#{section.id}/products"
      end
      it { expect(response).to have_http_status(:ok) }

      it { expect(json_body.dig('data').length).to eq(product_count) }
    end

    context 'when count products section active false' do
      let(:section) { create(:section, active: false) }
      before do
        create_list(:product, product_count, section: section)
        get "/v1/restaurants/sections/#{section.id}/products"
      end

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe 'GET /v1/restaurants/sections/{section_id}/products/{id}' do
    let(:product_count) { rand(1..10) }

    context 'when found product' do
      let(:section) { create(:section, active: true) }
      let(:product) { create(:product, active: true, section: section) }

      before do
        get "/v1/restaurants/sections/#{section.id}/products/#{product.id}"
      end
      it { expect(response).to have_http_status(:ok) }
    end

    context 'when not found product' do
      let(:section) { create(:section, active: true) }
      let(:product) { create(:product, active: false, section: section) }

      before do
        get "/v1/restaurants/sections/#{section.id}/products/#{product.id}"
      end
      it { expect(response).to have_http_status(:not_found) }
    end
  end
end
