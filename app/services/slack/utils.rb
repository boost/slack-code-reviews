# frozen_string_literal: true

module Slack
  class Utils
    def self.generate_params(text)
      {
        slack_workspace_id: ENV['SLACK_WORKSPACE_ID'] { 'SLACK_WORKSPACE_ID' },
        slack_workspace_domain: ENV['SLACK_WORKSPACE_DOMAIN'] { 'SLACK_WORKSPACE_DOMAIN' },
        channel_id: ENV['CHANNEL_ID'] { 'CHANNEL_ID' },
        channel_name: ENV['USER_ID'] { 'test-code-review' },
        user_id: ENV['USER_ID'] { 'SENDER_ID' },
        user_name: ENV['USER_NAME'] { 'sender.username' },
        token: 'slack_token',
        command: '/cr',
        response_url: 'https://hooks.slack.com/commands/ABC/DEF/GHI',
        trigger_id: '123.456.789',
        text: text
      }
    end

    def self.signature(slack_signing_secret, timestamp, params)
      params = RestClient::Utils.encode_query_string(params) if [Hash, RestClient::ParamsArray].include?(params.class)
      sig_basestring = "v0:#{timestamp}:#{params}"

      "v0=#{OpenSSL::HMAC.hexdigest('sha256', slack_signing_secret, sig_basestring)}"
    end
  end
end
