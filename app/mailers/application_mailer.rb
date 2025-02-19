# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@hitohi-hitonana.com'
  layout 'mailer'
end
