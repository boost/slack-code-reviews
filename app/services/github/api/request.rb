# frozen_string_literal: true

# Mother class for api calls
class Github::Api::Request
  BASE_URL = 'https://api.github.com'

  def self.post(path:, payload:)
    response = RestClient.post(
      "#{BASE_URL}#{path}",
      payload.to_json,
      authorization: "Token #{AccessToken.get}"
    )

    JSON.parse(response)
  rescue JSON::ParserError => e
    Rails.logger.debug(e)
    response
  end

end
