# frozen_string_literal: true

module Slack
  module Api
    # https://api.slack.com/methods/chat.postEphemeral
    class ChatPostEphemeral < Request
      def initialize(params)
        super('https://slack.com/api/chat.postEphemeral', params)
      end

      def call
        post
      end

      def required_arguments
        %w[text channel user]
      end

      def optional_arguments
        %w[
          as_user
          blocks
          icon_emoji
          icon_url
          link_names
          parse
          thread_ts
          username
        ]
      end
    end
  end
end
