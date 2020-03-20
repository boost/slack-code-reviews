# frozen_string_literal: true

module Github
  module Api
    # Mother class for api calls
    class Request
      BASE_URL = 'https://api.github.com'

      def self.post(path:, payload:)
        response = RestClient.post(
          "#{BASE_URL}#{path}",
          payload.to_json,
          content_type: :json, accept: :json, charset: 'utf-8',
          authorization: "token #{ENV['GITHUB_PERSONAL_ACCESS_TOKEN']}"
        )
        JSON.parse(response)
      rescue JSON::ParserError => e
        Rails.logger.debug(e)
        response
      end
    end
  end
end
