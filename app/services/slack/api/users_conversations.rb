# frozen_string_literal: true

module Slack
  module Api
    # https://api.slack.com/methods/users.info
    class UsersConversations < Request
      def initialize(params)
        super('https://slack.com/api/conversations.list', params)
      end

      def call
        get
      end
    end
  end
end
