# frozen_string_literal: true

module Slack
  module Api
    # https://api.slack.com/methods/views.update
    class ViewsUpdate < Request
      def initialize(params)
        super('https://slack.com/api/views.update', params)
      end

      def call
        post
      end
    end
  end
end
