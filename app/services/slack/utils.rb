# frozen_string_literal: true

module Slack
  class Utils
    def self.generate_params(text)
      {
        team_id: Figaro.env.team_id || 'TEAM_ID',
        team_domain: Figaro.env.team_domain || 'TEAM_DOMAIN',
        channel_id: Figaro.env.channel_id || 'CHANNEL_ID',
        channel_name: Figaro.env.user_id || 'test-code-review',
        user_id: Figaro.env.user_id || 'SENDER_ID',
        user_name: Figaro.env.user_name || 'sender.username',
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
