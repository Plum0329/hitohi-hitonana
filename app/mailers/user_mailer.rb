# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def confirmation_email
    @user = params[:user]
    @url = confirm_email_url(confirmation_token: @user.confirmation_token)
    mail(to: @user.email, subject: 'メールアドレスの確認')
  end
end
