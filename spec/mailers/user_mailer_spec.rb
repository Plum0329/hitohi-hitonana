# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  include Rails.application.routes.url_helpers

  describe 'confirmation_email' do
    let(:user) { create(:user) }
    let(:mail) { described_class.with(user: user).confirmation_email }

    before do
      Rails.application.routes.default_url_options[:host] = 'example.com'
    end

    describe 'headers' do
      it 'renders the subject' do
        expect(mail.subject).to eq('メールアドレスの確認')
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([user.email])
      end

      it 'renders the sender email' do
        expect(mail.from).to eq(['noreply@hitohi-hitonana.com'])
      end
    end

    describe 'body' do
      it 'includes user name in text part' do
        expect(mail.text_part.body.decoded).to include(user.name)
      end

      it 'includes confirmation URL in text part' do
        expect(mail.text_part.body.decoded).to include(
          confirm_email_url(confirmation_token: user.confirmation_token)
        )
      end

      it 'includes user name in HTML part' do
        expect(mail.html_part.body.decoded).to include(user.name)
      end

      it 'includes confirmation URL in HTML part' do
        expect(mail.html_part.body.decoded).to include(
          confirm_email_url(confirmation_token: user.confirmation_token)
        )
      end
    end
  end
end
