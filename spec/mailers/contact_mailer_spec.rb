# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContactMailer, type: :mailer do
  describe '#confirmation_email' do
    let(:contact) { create(:contact) }
    let(:mail) { described_class.confirmation_email(contact) }

    it 'has correct subject' do
      expect(mail.subject).to eq('お問い合わせを受け付けました')
    end

    it 'sends to correct email' do
      expect(mail.to).to eq([contact.email])
    end

    it 'sends from correct email' do
      expect(mail.from).to eq(['noreply@hitohi-hitonana.com'])
    end

    context 'with email body' do
      it 'includes contact name in text part' do
        expect(mail.text_part.body.decoded).to include(contact.name)
      end

      it 'includes contact email in text part' do
        expect(mail.text_part.body.decoded).to include(contact.email)
      end

      it 'includes contact content in text part' do
        expect(mail.text_part.body.decoded).to include(contact.content)
      end

      it 'includes contact name in html part' do
        expect(mail.html_part.body.decoded).to include(contact.name)
      end

      it 'includes contact email in html part' do
        expect(mail.html_part.body.decoded).to include(contact.email)
      end

      it 'includes contact content in html part' do
        expect(mail.html_part.body.decoded).to include(contact.content)
      end
    end
  end
end
