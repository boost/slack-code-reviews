# frozen_string_literal: true

module Slack
  module Api
    # Mother class for api calls
    class Request
      def initialize(url, params)
        @url = url
        @params = params
      end

      def get
        response = RestClient.get(
          "#{@url}?#{RestClient::Utils.encode_query_string(@params)}",
          authorization: "Bearer #{ENV['SLACK_OAUTH_ACCESS_TOKEN']}"
        )

        JSON.parse(response.body)
      end
    end
  end
end
