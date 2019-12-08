# frozen_string_literal: true

# The ApplicationMailer class defines some defaults that are used across the
# other mailers
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
