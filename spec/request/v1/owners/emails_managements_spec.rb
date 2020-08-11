require 'rails_helper'
RSpec.describe 'Emails Managements', type: :request do
  let(:owner) { create(:owner) }

  describe 'GET /v1/owners/emails?email={email}' do
    it 'find email' do
      get '/v1/owners/emails', params: { email: owner.email }
      expect(response).to have_http_status(:ok)
    end

    it 'not found' do
      get '/v1/owners/emails', params: { email: Faker::Internet.email }

      expect(response).to have_http_status(:not_found)
    end

    context 'when email is blank' do
      before {
        get '/v1/owners/emails', params: { email: '' }
      }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(json_body['email']).to match_array([I18n.t('errors.messages.blank')]) }
    end
  end
end
