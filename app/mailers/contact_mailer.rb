# frozen_string_literal: true

class ContactMailer < ApplicationMailer
  def confirmation_email(contact)
    @contact = contact
    mail(
      to: @contact.email,
      subject: 'お問い合わせを受け付けました'
    )
  end
end
