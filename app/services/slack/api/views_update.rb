# frozen_string_literal: true

module Slack
  module Api
    # https://api.slack.com/methods/views.update
    class ViewsUpdate < Request
      def initialize(payload)
        super('https://slack.com/api/views.update', payload: payload)
      end

      def call
        post
      end
    end
  end
end
