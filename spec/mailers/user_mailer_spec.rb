# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'confirmation_email' do
    let(:user) { create(:user) }
    let(:mail) { described_class.with(user: user).confirmation_email }

    it 'renders the headers' do
      expect(mail.subject).to eq('メールアドレスの確認')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['noreply@hitohi-hitonana.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(user.name)
      expect(mail.body.encoded).to match(user.confirmation_token)
    end
  end
end
