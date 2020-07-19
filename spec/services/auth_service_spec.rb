require 'rails_helper'

RSpec.describe AuthService do
  let(:owner) { create(:owner) }

  describe 'when create or update token to owner' do
    context 'when new' do
      it 'when have token' do
        described_class.create_token(authenticator: owner, request: FakeRequest.new)
        expect(owner.authenticate_tokens).to be_truthy
      end

      it 'when return token' do
        auth = described_class.create_token(authenticator: owner, request: FakeRequest.new)
        expect(auth).to eq(owner.authenticate_tokens.last.body)
      end
    end

    context 'when update token' do
      let(:fake_request) { FakeRequest.new }
      let(:old_token) { create(:authenticate_token, authenticator: owner, user_agent: fake_request.user_agent).body }
      let(:new_token) { described_class.create_token(authenticator: owner, request: fake_request) }

      it 'return new token' do
        expect(old_token).not_to eq(new_token)
      end

      it 'update existing' do
        old_token
        new_token
        expect(owner.authenticate_tokens).not_to eq(1)
      end
    end
  end

  describe 'when find token' do
    let(:token) { create(:authenticate_token, authenticator: owner).body }

    it 'when find' do
      auth = described_class.find_token(token)
      expect(auth).to eq(owner)
    end

    it 'when not found' do
      auth = described_class.create_token(authenticator: owner, request: FakeRequest.new)
      expect(auth).to eq(owner.authenticate_tokens.last.body)
    end
  end

  describe 'when destroy token' do
    let(:fake_request) { FakeRequest.new }

    before do
      create(:authenticate_token, authenticator: owner, user_agent: fake_request.user_agent)
      create(:authenticate_token, authenticator: owner, user_agent: 'opera')
    end

    it 'when yet destroy' do
      expect(owner.authenticate_tokens.count).to eq(2)
    end

    it 'when destroy' do
      described_class.destroy_token(authenticator: owner, request: fake_request)
      expect(owner.authenticate_tokens.count).to eq(1)
    end
  end
end
