# frozen_string_literal: true

module Slack
  module Api
    # https://api.slack.com/methods/views.open
    class ViewsOpen < Request
      def initialize(params)
        super('https://slack.com/api/views.open', params)
      end

      def call
        post
      end
    end
  end
end
