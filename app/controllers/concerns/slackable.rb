# frozen_string_literal: true

module Slackable
  extend ActiveSupport::Concern

  private

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

    # return false if the request was made more than 5 minutes ago
    # The signature depends on the timestamp to protect against replay attacks
    def timestamp_ok?(timestamp)
      @error = "ERROR: you're not Slack (wrong timestamp)" if (Time.now - Time.at(timestamp.to_i)).abs / 1.second > 5.minute

      @error.blank?
    end

    # check that the signature sent by slack matches the computed one
    def signature_ok?(timestamp)
      slack_signature = request.headers['X-Slack-Signature']
      signature = Slack::Utils.signature(SLACK_SIGNING_SECRET, timestamp, request.raw_post)

      @error = "ERROR: you're not Slack (wrong signature)" if slack_signature != signature
      @error.blank?
    end
end
