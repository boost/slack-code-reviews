# frozen_string_literal: true

class Github::Api::AccessToken < Github::Api::Request

  def self.get
    response = RestClient.post(
      "#{BASE_URL}/app/installations/#{ENV['GITHUB_APP_INSTALLATION_ID']}/access_tokens",
      {}.to_json,
      accept: 'application/vnd.github.machine-man-preview+json',
      authorization: "Bearer #{generate_jwt}"
    )

    # {
    #   "token"=>"v1.2f...",
    #   "expires_at"=>"2020-06-29T21:52:53Z",
    #   "permissions"=>{"metadata"=>"read", "pull_requests"=>"write"},
    #   "repository_selection"=>"all"
    # }

    JSON.parse(response)['token']
  rescue JSON::ParserError => e
    Rails.logger.debug(e)
    response
  end

  private_key

    def generate_jwt
      payload = {
        iat: Time.current.to_i,        # Issued at
        exp: 10.minutes.from_now.to_i, # Expires at (10 minute maximum)
        iss: ENV['GITHUB_APP_ID']
      }

      private_key = OpenSSL::PKey::RSA.new(
        Base64.decode64(ENV['GITHUB_APP_PRIVATE_KEY'])
      )

      JWT.encode(payload, private_key, 'RS256')
    end

end
