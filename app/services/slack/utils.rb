# frozen_string_literal: true

module Slack
  # This is used in the codereview rake task to generate a valid Slack
  # signature and verify it in the Slackable concern
  # See here: https://api.slack.com/docs/verifying-requests-from-slack
  class Utils
    def self.signature(slack_signing_secret, timestamp, params)
      params = RestClient::Utils.encode_query_string(params) if [Hash, RestClient::ParamsArray].include?(params.class)

      encoded_string = OpenSSL::HMAC.hexdigest(
        'sha256',
        slack_signing_secret,
        "v0:#{timestamp}:#{params}"
      )

      "v0=#{encoded_string}"
    end
  end
end
