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

    it 'renders the headers' do
      expect(mail.subject).to eq('メールアドレスの確認')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['noreply@hitohi-hitonana.com'])
    end

    it 'renders the body' do
      expect(mail.text_part.body.decoded).to include(user.name)
      expect(mail.text_part.body.decoded).to include(
        confirm_email_url(confirmation_token: user.confirmation_token)
      )

      expect(mail.html_part.body.decoded).to include(user.name)
      expect(mail.html_part.body.decoded).to include(
        confirm_email_url(confirmation_token: user.confirmation_token)
      )
    end
  end
end
