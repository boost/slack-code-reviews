# frozen_string_literal: true

module Slack
  module Api
    # https://api.slack.com/methods/users.info
    class ChatPostMessage < Request
      def initialize(params)
        super('https://slack.com/api/chat.postMessage', params)
        @token = ENV['SLACK_BOT_USER_OAUTH_ACCESS_TOKEN']
      end

      def call
        post
      end
    end
  end
end
