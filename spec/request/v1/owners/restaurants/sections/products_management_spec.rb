require 'rails_helper'

RSpec.describe 'Product management', type: :request do
  let(:owner) { create(:owner) }
  let(:restaurant) { create(:restaurant, owner: owner) }
  let(:section) { create(:section, restaurant: restaurant) }
  let(:product_attrs) {
    {
      product: {
        name: Faker::Company.name,
        active: true,
        price: '10.00',
        descrition: Faker::Lorem.paragraph_by_chars(number: 100, supplemental: false),
        image: {
          data: image_base_64
        }
      }
    }
  }

  describe 'GET /v1/owners/restaurants/sections/{section_id}/products' do
    let(:product_count) { rand(1..10) }

    context 'when count restaurants' do
      before do
        create_list(:product, product_count, section: section)
        create_list(:product, product_count)
        get "/v1/owners/restaurants/sections/#{section.id}/products", headers: header_with_authentication(owner)
      end
      it { expect(response).to have_http_status(:ok) }

      it { expect(json_body.dig('data').length).to eq(product_count) }
    end

    context 'when count restaurants unauthorized' do
      before do
        create_list(:section, product_count, restaurant: restaurant)
        create_list(:section, product_count)
        get "/v1/owners/restaurants/#{restaurant.id}/sections", headers: header_with_authentication(create(:owner))
      end
      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe 'POST /v1/owners/restaurants/sections/{section_id}/products' do
    context 'when create success' do
      before do
        post "/v1/owners/restaurants/sections/#{section.id}/products", params: product_attrs.to_json,
                                                                       headers: header_with_authentication(owner)
      end

      it { expect(response).to have_http_status(:created) }

      it { expect(json_body.dig('data', 'attributes', 'active')).to be_truthy }
    end

    context 'when create fail' do
      before do
        product_attrs[:product][:name] = ''
        post "/v1/owners/restaurants/sections/#{section.id}/products", params: product_attrs.to_json,
                                                                       headers: header_with_authentication(owner)
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it { expect(json_body['name']).to match_array([I18n.t('errors.messages.blank')]) }
    end
  end

  describe 'PUT /v1/owners/restaurants/sections/{section_id}/products/{id}' do
    let(:product) { create(:product, section: section) }
    let(:name) { Faker::Company.name }

    context 'when section update' do
      before do
        product_attrs[:product][:name] = name
        endpoint = "/v1/owners/restaurants/sections/#{section.id}/products/#{product.id}"
        put endpoint, params: product_attrs.to_json,
                      headers: header_with_authentication(owner)
      end

      it { expect(response).to have_http_status(:accepted) }

      it { expect(json_body.dig('data', 'attributes', 'name')).to eq(name) }

      it { expect(json_body.dig('data', 'attributes', 'image')).to be_truthy }
    end

    context 'when section update section_id' do
      let(:section_2) { create(:section, restaurant: restaurant) }

      before do
        product_attrs[:product][:section_id] = section_2.id
        endpoint = "/v1/owners/restaurants/sections/#{section.id}/products/#{product.id}"
        put endpoint, params: product_attrs.to_json,
                      headers: header_with_authentication(owner)
      end

      it { expect(response).to have_http_status(:accepted) }

      it { expect(section_2.products.find(product.id)).to be_truthy }
    end

    context 'when section update (remove_image)' do
      before do
        product_attrs[:product][:image_destroy] = true
        endpoint = "/v1/owners/restaurants/sections/#{section.id}/products/#{product.id}"
        put endpoint, params: product_attrs.to_json,
                      headers: header_with_authentication(owner)
      end

      it { expect(response).to have_http_status(:accepted) }

      it { expect(json_body.dig('data', 'attributes', 'image')).to be_nil }
    end

    context 'when update fail' do
      before do
        product_attrs[:product][:name] = ''
        endpoint = "/v1/owners/restaurants/sections/#{section.id}/products/#{product.id}"
        put endpoint, params: product_attrs.to_json,
                      headers: header_with_authentication(owner)
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it { expect(json_body['name']).to match_array([I18n.t('errors.messages.blank')]) }
    end
  end

  describe 'GET /v1/owners/restaurants/section/{section_id}/products/{id}' do
    let(:product) { create(:product, section: section) }

    context 'when find product' do
      before do
        get "/v1/owners/restaurants/sections/#{section.id}/products/#{product.id}", headers: header_with_authentication(owner)
      end

      it { expect(response).to have_http_status(:ok) }

      it { expect(json_body.dig('data', 'attributes', 'name')).to eq(product.name) }
    end

    context 'when not found product' do
      before do
        get "/v1/owners/restaurants/sections/#{section.id}/products/0", headers: header_with_authentication(owner)
      end

      it { expect(response).to have_http_status(:not_found) }
    end

    context 'when product is of other restaurant (not found)' do
      before do
        get "/v1/owners/restaurants/sections/#{section.id}/products/#{create(:product).id}", headers: header_with_authentication(owner)
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe 'PUT /v1/owners/restaurants/sections/{section_id}/products/sort' do
    let(:products) { create_list(:product, 10, section: section) }
    let(:ids) {
      products.pluck(:id).reverse + create_list(:product, 2).pluck(:id)
    }
    let(:product_attrs) {
      {
        product: {
          ids: ids
        }
      }
    }

    before do
      put "/v1/owners/restaurants/sections/#{section.id}/products/sort", params: product_attrs.to_json,
                                                                         headers: header_with_authentication(owner)
    end

    it { expect(section.products.sort_by_position.ids).to eq(products.pluck(:id).reverse) }
  end

  describe 'DELETE /v1/owners/restaurants/sections/{section_id}/product/{id}' do
    let(:product) { create(:product, section: section) }

    context 'when delete product success' do
      before {
        delete "/v1/owners/restaurants/sections/#{section.id}/products/#{product.id}", headers: header_with_authentication(owner)
      }

      it { expect(response).to have_http_status(:no_content) }

      it { expect(Product.find_by(id: section.id)).to be_nil }
    end
  end
end
