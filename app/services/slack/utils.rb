# frozen_string_literal: true

module Slack
  # This is used in the codereview rake task to generate a valid Slack
  # signature and verify it in the Slackable concern
  # See here: https://api.slack.com/docs/verifying-requests-from-slack
  class Utils
    def self.generate_params(text)
      {
        slack_workspace_id: ENV.fetch('SLACK_WORKSPACE_ID') { 'WORKSPACE' },
        slack_workspace_domain: ENV.fetch('SLACK_WORKSPACE_DOMAIN', 'WORK_D'),
        channel_id: ENV.fetch('CHANNEL_ID') { 'CHANNEL_ID' },
        channel_name: ENV.fetch('USER_ID') { 'test-code-review' },
        user_id: ENV.fetch('USER_ID') { 'SENDER_ID' }, trigger_id: '123.456.78',
        user_name: ENV.fetch('USER_NAME') { 'sender.username' },
        token: 'slack_token', command: '/cr', text: text,
        response_url: 'https://hooks.slack.com/commands/ABC/DEF/GHI'
      }
    end

    def self.signature(slack_signing_secret, timestamp, params)
      if [Hash, RestClient::ParamsArray].include?(params.class)
        params = RestClient::Utils.encode_query_string(params)
      end

      encoded_string = OpenSSL::HMAC.hexdigest(
        'sha256',
        slack_signing_secret,
        "v0:#{timestamp}:#{params}"
      )

      "v0=#{encoded_string}"
    end
  end
end
