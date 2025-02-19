# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContactMailer, type: :mailer do
  describe '#confirmation_email' do
    let(:contact) { create(:contact) }
    let(:mail) { described_class.confirmation_email(contact) }

    it 'renders the headers' do
      expect(mail.subject).to eq('お問い合わせを受け付けました')
      expect(mail.to).to eq([contact.email])
      expect(mail.from).to eq(['noreply@hitohi-hitonana.com'])
    end

    it "renders the body" do
      expect(mail.text_part.body.decoded).to include(contact.name)
      expect(mail.text_part.body.decoded).to include(contact.email)
      expect(mail.text_part.body.decoded).to include(contact.content)

      expect(mail.html_part.body.decoded).to include(contact.name)
      expect(mail.html_part.body.decoded).to include(contact.email)
      expect(mail.html_part.body.decoded).to include(contact.content)
    end
  end
end
