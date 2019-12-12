# frozen_string_literal: true

module Slack
  module Api
    # https://api.slack.com/methods/users.info
    class UserInfo < Request
      def initialize(user_id)
        super('https://slack.com/api/users.info', user: user_id)
      end

      def call
        get
      end
    end
  end
end
