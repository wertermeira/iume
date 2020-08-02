require 'rails_helper'
RSpec.describe 'Feedbacks Managements', type: :request do
  let(:owner) { create(:owner) }
  let(:valid_attrs) {
    {
      feedback: {
        screen: 'screen',
        body: Faker::Lorem.question(word_count: 10, supplemental: false)
      }
    }
  }
  describe 'POST /v1/owners/feedbacks' do
    context 'when create success' do
      before { post '/v1/owners/feedbacks', params: valid_attrs.to_json, headers: header_with_authentication(owner) }

      it { expect(response).to have_http_status(:created) }

      it { expect(json_body.dig('data', 'attributes', 'body')).to eq(valid_attrs[:feedback][:body]) }
    end

    context 'when create fail' do
      before do
        valid_attrs[:feedback][:body] = ''
        post '/v1/owners/feedbacks', params: valid_attrs.to_json, headers: header_with_authentication(owner)
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it { expect(json_body.dig('body')).to match_array([I18n.t('errors.messages.blank')]) }
    end
  end
end
