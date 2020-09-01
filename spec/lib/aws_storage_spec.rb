require 'rails_helper'

RSpec.describe AwsStorage do
  context 'when AwsStorage' do
    let(:options) {
      {
        stub_responses: true,
        region: 'us-east-1',
        access_key_id: 'akid',
        secret_access_key: 'secret'
      }
    }

    let(:client_class) { Aws::S3::Client }

    it 'check credentails e bucket'
  end
end
