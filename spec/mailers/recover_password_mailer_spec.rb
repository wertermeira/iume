require 'rails_helper'

RSpec.describe RecoverPasswordMailer, type: :mailer do
  describe 'when email send owner' do
    let(:user) { create(:owner) }
    let(:token) { create(:authenticate_token, authenticator: user).body }
    let(:mail) {
      described_class.send_to_user(user: user, token: token).deliver_now
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
        expect(mail.to).to eq([user.email])
      end
    end
  end
end
