# frozen_string_literal: true

# enables a controller to set the instance variable @error when the Slack
# integrity check fails
module Slackable
  extend ActiveSupport::Concern

  Unauthorized = Class.new(StandardError)

private

  # See here: https://api.slack.com/docs/verifying-requests-from-slack
  def verify_slack_identity
    timestamp = request.headers['X-Slack-Request-Timestamp']

    return unless timestamp_ok?(timestamp)
    return unless signature_ok?(timestamp)
  end

  # return false if the request was made more than 5 minutes ago
  # The signature depends on the timestamp to protect against replay attacks
  # See https://api.slack.com/docs/verifying-requests-from-slack
  def timestamp_ok?(timestamp)
    return unless (Time.now - Time.at(timestamp.to_i)).abs / 1.second > 5.minute

    raise Unauthorized "ERROR: you're not Slack!"
  end

  # check that the signature sent by slack matches the computed one
  def signature_ok?(timestamp)
    slack_signature = request.headers['X-Slack-Signature']
    signature = Slack::Utils.signature(
      SLACK_SIGNING_SECRET, timestamp, request.raw_post
    )

    return unless slack_signature != signature

    raise Unauthorized, "ERROR: you're not Slack (wrong signature)"
  end
end
