# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer_mailer
class UserMailerPreview < ActionMailer::Preview
  def confirmation_email
    user = User.first || User.create!(
      email: 'preview@example.com',
      password: 'password',
      password_confirmation: 'password',
      name: 'Preview User'
    )
    UserMailer.with(user: user).confirmation_email
  end
end
