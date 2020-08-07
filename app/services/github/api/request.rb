# frozen_string_literal: true

# Mother class for api calls
module Github
  module Api
    class Request
      BASE_URL = 'https://api.github.com'

      def self.post(path:, payload:)
        token = Github::Api::AccessToken.get
        # binding.pry
        response = RestClient.post(
          "#{BASE_URL}#{path}",
          payload.to_json,
          authorization: "Token #{token}"
        )

        JSON.parse(response)
      rescue JSON::ParserError => e
        Rails.logger.debug(e)
        response
      rescue RestClient::UnprocessableEntity => e
        Rails.logger.debug(e)
      end
    end
  end
end
