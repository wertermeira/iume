require 'rails_helper'

RSpec.describe WelcomeMailer, type: :mailer do
  describe 'when email send owner' do
    let(:owner) { create(:owner) }
    let(:mail) {
      described_class.send_to_owner(owner).deliver_now
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
        expect(mail.subject).to eq(I18n.t('mailer.messages.welcome.subject'))
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([owner.email])
      end

      it 'assigns summary' do
        expect(mail.body.encoded).to match(I18n.t('mailer.messages.welcome.summary'))
      end
    end
  end
end
