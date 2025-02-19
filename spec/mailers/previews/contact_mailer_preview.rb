# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer_mailer
class ContactMailerPreview < ActionMailer::Preview
  def confirmation_email
    contact = Contact.new(
      name: 'Preview User',
      email: 'preview@example.com',
      category: 'service',
      content: "これはテストのお問い合わせ内容です。\n改行を含む内容です。"
    )
    ContactMailer.confirmation_email(contact)
  end
end
