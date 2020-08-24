require 'rails_helper'

RSpec.describe RecoverPasswordMailer, type: :mailer do
  describe 'when email send owner' do
    let(:owner) { create(:owner) }
    let(:token) { create(:authenticate_token, authenticator: owner).body }
    let(:mail) {
      described_class.send_to_owner(owner: owner, token: token).deliver_now
    }

    context 'with headers of email' do
      it 'from' do
        expect(mail.from).to eq("#{ENV['APP_NAME']} <#{ENV['EMAIL_SENDER']}>")
      end

      it 'reply to' do
        expect(mail.reply_to).to eq("No Reply: #{ENV['APP_NAME']} <#{ENV['EMAIL_SENDER']}>")
      end
    end

    context 'when sent email' do
      it 'renders the subject' do
        expect(mail.subject).to eq(I18n.t('mailer.messages.reset_password'))
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([owner.email])
      end
    end

    context 'when body encoded' do
      it 'assigns url with token' do
        expect(mail.body.encoded).to match("#{ENV['FROENTEND_URL']}/recover/#{@token}")
      end
    end
  end
end
