require 'rails_helper'

RSpec.describe AuthenticateToken, type: :model do
  context 'when db schema' do
    let(:model) { described_class.column_names }

    %w[id body last_used_at expires_in user_agent authenticateable_type authenticateable_id].each do |column|
      it "have column #{column}" do
        expect(model).to include(column)
      end
    end
  end

  context 'when have associations' do
    it { is_expected.to belong_to(:authenticateable) }
  end

  context 'when update token' do
    let(:owner) { create(:owner) }

    it 'new token' do
      old_token = create(:authenticate_token, authenticator: owner).body
      owner.authenticate_tokens.last.update_token
      new_token = owner.authenticate_tokens.last.body
      expect(old_token).not_to eq(new_token)
    end
  end
end
