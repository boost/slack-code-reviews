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
        @token ||= ENV['SLACK_OAUTH_ACCESS_TOKEN']
        JSON.parse(
          RestClient.get(
            "#{@url}?#{RestClient::Utils.encode_query_string(@params)}",
            authorization: "Bearer #{@token}"
          )
        )
      end

      def post
        @token ||= ENV['SLACK_OAUTH_ACCESS_TOKEN']
        payload = case @params
                  when String then @params
                  when ActionView::OutputBuffer then @params
                  else @params.to_json
                  end
        response = RestClient.post(
          @url,
          payload,
          content_type: :json, accept: :json, charset: 'utf-8',
          authorization: "Bearer #{@token}"
        )
        JSON.parse(response)
      rescue JSON::ParserError => e
        if response != 'ok'
          Rails.logger.debug("JSON::ParserError: #{e.message}")
          Rails.logger.debug("JSON::ParserError parsed string: #{response}")
        end
        response
      end
    end
  end
end
