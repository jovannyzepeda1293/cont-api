# frozen_string_literal: true

# ApplicationMailer
class ApplicationMailer < ActionMailer::Base
  default from: 'contalink@test.com'
  layout 'mailer'
  prepend_view_path Rails.root.join('app/views/mailers')
end
