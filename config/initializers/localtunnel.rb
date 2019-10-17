# frozen_string_literal: true

Rails.application.config.hosts << 'slack-code-reviews.localtunnel.me' if Rails.env == 'development'

Rails.application.config.after_initialize do
  if defined?(::Rails::Server) && Rails.env == 'development'
    host = ''
    subdomain = Figaro.env.local_tunnel_subdomain!

    while (host =~ /#{subdomain}/).blank?
      Localtunnel::Client.stop
      Localtunnel::Client.start(port: 3000, subdomain: subdomain)

      puts "Local tunnel: #{Localtunnel::Client.url}"
      host = URI.parse(Localtunnel::Client.url).host
    end
  end
end
