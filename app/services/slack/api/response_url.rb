# frozen_string_literal: true

module Slack
  module Api
    # used when Slack is providing the response_url to post to
    class ResponseUrl < Request
      def initialize(url, payload)
        super(url, payload: payload)
      end

      def call
        post
      end
    end
  end
end
