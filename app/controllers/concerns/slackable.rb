# frozen_string_literal: true

module Slackable
  extend ActiveSupport::Concern

  before_action :verify_slack_identity

  # See here: https://api.slack.com/docs/verifying-requests-from-slack
  def verify_slack_identity
    timestamp = request.headers['X-Slack-Request-Timestamp']

    return unless timestamp_ok?(timestamp)
    return unless signature_ok?(timestamp)
  end

  def render_error
    render json: {
      response_type: :ephemeral,
      text: @error
    }
  end

  private

    # return false if the request was made more than 5 minutes ago
    # The signature depends on the timestamp to protect against replay attacks
    def timestamp_ok?(timestamp)
      @error = 'Sorry, the time looks wrong. Please try again' if (Time.now - Time.at(timestamp.to_i)).abs / 1.second > 5.minute

      @error.blank?
    end

    # check that the signature sent by slack matches the computed one
    def signature_ok?(timestamp)
      sig_basestring = "v0:#{timestamp}:#{request.raw_post}"
      slack_signature = request.headers['X-Slack-Signature']

      signature = [
        'v0=',
        OpenSSL::HMAC.hexdigest('sha256', SLACK_SIGNING_SECRET, sig_basestring)
      ].join

      @error = 'Sorry, the signature is wrong' if slack_signature != signature
      @error.blank?
    end
end
