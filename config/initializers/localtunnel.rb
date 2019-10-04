# frozen_string_literal: true

if Rails.env == 'development'
  Rails.application.config.hosts << 'slack-code-reviews.localtunnel.me'
end

Rails.application.config.after_initialize do
  if defined?(::Rails::Server) && Rails.env == 'development'
    host = ''
    subdomain = 'slack-code-reviews'

    while (host =~ /#{subdomain}/).blank?
      Localtunnel::Client.stop
      Localtunnel::Client.start(port: 3000, subdomain: subdomain)


      puts "Local tunnel: #{Localtunnel::Client.url}"
      host = URI.parse(Localtunnel::Client.url).host
    end
  end
end
