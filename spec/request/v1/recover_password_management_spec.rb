require 'rails_helper'

RSpec.describe 'RecoverPassword management', type: :request do
  describe 'POST /v1/recover_password/owner' do
    let(:owner) { create(:owner) }
    let(:valid_attrs) {
      {
        recover: {
          email: owner.email
        }
      }
    }
    let(:invalid_attrs) {
      {
        recover: {
          email: 'other@site.com'
        }
      }
    }

    context 'when recover success' do
      before { post '/v1/recover_password/owner', params: valid_attrs }

      it { expect(response).to have_http_status(:created) }

      it do
        expect(json_body['message']).to eq(I18n.t('mailer.messages.check_your_mailbox'))
      end
    end

    context 'when recover email invalid' do
      before { post '/v1/recover_password/owner', params: invalid_attrs }

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it do
        expect(json_body['errors']['email']).to eq(I18n.t('errors.messages.email_not_found'))
      end
    end

    context 'when recover params not found' do
      before { post '/v1/recover_password/other' }

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe 'PUT /v1/recover_password/owner' do
    let(:owner) { create(:owner) }
    let(:new_password) { '123456789' }
    let(:valid_attrs) {
      {
        recover: {
          password: new_password,
          password_confirmation: new_password
        }
      }
    }
    let(:invalid_attrs) {
      {
        recover: {
          password: '123456789x',
          password_confirmation: 'x123456789'
        }
      }
    }

    context 'when update password success' do
      before {
        put '/v1/recover_password/owner/me', params: valid_attrs.to_json,
                                             headers: header_with_authentication(owner)
      }

      it { expect(response).to have_http_status(:accepted) }

      it do
        expect(response.body).to be_empty
      end

      it do
        expect(owner.reload.authenticate(new_password)).to be_truthy
      end
    end

    context 'when update passoword fail' do
      before {
        put '/v1/recover_password/owner/me', params: invalid_attrs.to_json,
                                             headers: header_with_authentication(owner)
      }

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it {
        expect(json_body['password_confirmation']).to eq(["doesn't match Password"])
      }
    end
  end
end
