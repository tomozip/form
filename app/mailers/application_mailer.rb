# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'WelcomeForm.com'
  layout 'mailer'
end
