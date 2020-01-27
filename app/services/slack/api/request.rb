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
        JSON.parse(
          RestClient.get(
            "#{@url}?#{RestClient::Utils.encode_query_string(@params)}",
            authorization: "Bearer #{ENV['SLACK_OAUTH_ACCESS_TOKEN']}"
          )
        )
      end

      def post
        puts @params
        JSON.parse(
          RestClient.post(
            @url,
            @params,
            content_type: :json, accept: :json, charset: 'utf-8',
            authorization: "Bearer #{ENV['SLACK_OAUTH_ACCESS_TOKEN']}"
          )
        )
      end
    end
  end
end
