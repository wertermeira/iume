require 'rails_helper'

RSpec.describe 'Section management', type: :request do
  let(:owner) { create(:owner) }
  let(:restaurant) { create(:restaurant, owner: owner) }
  let(:section_attrs) {
    {
      section: {
        name: Faker::Company.name,
        active: true
      }
    }
  }

  describe 'GET /v1/owners/restaurants/{restaurant_id}/sections' do
    let(:section_count) { rand(1..10) }

    context 'when count sections' do
      before do
        create_list(:section, section_count, restaurant: restaurant)
        create_list(:section, section_count)
        get "/v1/owners/restaurants/#{restaurant.uid}/sections", headers: header_with_authentication(owner)
      end
      it { expect(response).to have_http_status(:ok) }

      it { expect(json_body.dig('data').length).to eq(section_count) }
    end

    context 'when unauthorized' do
      before do
        create_list(:section, section_count, restaurant: restaurant)
        create_list(:section, section_count)
        get "/v1/owners/restaurants/#{restaurant.uid}/sections", headers: header_with_authentication(create(:owner))
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe 'POST /v1/owners/restaurants/{restaurant_id}/sections' do
    context 'when create success' do
      before do
        post "/v1/owners/restaurants/#{restaurant.uid}/sections", params: section_attrs.to_json,
                                                                  headers: header_with_authentication(owner)
      end

      it { expect(response).to have_http_status(:created) }
    end

    context 'when create fail' do
      before do
        section_attrs[:section][:name] = ''
        post "/v1/owners/restaurants/#{restaurant.uid}/sections", params: section_attrs.to_json,
                                                                  headers: header_with_authentication(owner)
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it { expect(json_body['name']).to match_array([I18n.t('errors.messages.blank')]) }
    end
  end

  describe 'PUT /v1/owners/restaurants/{retaurant_id}/sections/{id}' do
    let(:section) { create(:section, restaurant: restaurant) }
    let(:name) { Faker::Company.name }

    context 'when section update' do
      before do
        section_attrs[:section][:name] = name
        endpoint = "/v1/owners/restaurants/#{restaurant.uid}/sections/#{section.id}"
        put endpoint, params: section_attrs.to_json,
                      headers: header_with_authentication(owner)
      end

      it { expect(response).to have_http_status(:accepted) }

      it { expect(json_body.dig('data', 'attributes', 'name')).to eq(name) }
    end

    context 'when update fail' do
      before do
        section_attrs[:section][:name] = ''
        endpoint = "/v1/owners/restaurants/#{restaurant.uid}/sections/#{section.id}"
        put endpoint, params: section_attrs.to_json,
                      headers: header_with_authentication(owner)
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it { expect(json_body['name']).to match_array([I18n.t('errors.messages.blank')]) }
    end
  end

  describe 'GET /v1/owners/restaurants/{restaurant_id}/section/{id}' do
    let(:section) { create(:section, restaurant: restaurant) }

    context 'when find section' do
      before do
        get "/v1/owners/restaurants/#{restaurant.uid}/sections/#{section.id}", headers: header_with_authentication(owner)
      end

      it { expect(response).to have_http_status(:ok) }

      it { expect(json_body.dig('data', 'attributes', 'name')).to eq(section.name) }
    end

    context 'when not found section' do
      before do
        get "/v1/owners/restaurants/#{restaurant.uid}/sections/0", headers: header_with_authentication(owner)
      end

      it { expect(response).to have_http_status(:not_found) }
    end

    context 'when section other restaurant (not found)' do
      before do
        get "/v1/owners/restaurants/#{restaurant.uid}/sections/#{create(:section).id}", headers: header_with_authentication(owner)
      end

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe 'PUT /v1/owners/restaurants/{restaurant_id}/sections/sort' do
    let(:sections) { create_list(:section, 10, restaurant: restaurant) }
    let(:section_attrs) {
      {
        section: {
          ids: sections.pluck(:id).reverse
        }
      }
    }

    before do
      put "/v1/owners/restaurants/#{restaurant.uid}/sections/sort", params: section_attrs.to_json,
                                                                    headers: header_with_authentication(owner)
    end

    it { expect(restaurant.reload.sections.sort_by_position.ids).to eq(sections.pluck(:id).reverse) }
  end

  describe 'DELETE /v1/owners/restaurants/{restaurant_id}/sections/{id}' do
    let(:section) { create(:section, restaurant: restaurant) }

    context 'when delete section success' do
      before {
        delete "/v1/owners/restaurants/#{restaurant.uid}/sections/#{section.id}", headers: header_with_authentication(owner)
      }

      it { expect(response).to have_http_status(:no_content) }

      it { expect(Section.find_by(id: section.id)).to be_nil }
    end
  end
end
