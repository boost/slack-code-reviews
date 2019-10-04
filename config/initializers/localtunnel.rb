# frozen_string_literal: true

Rails.application.config.after_initialize do
  if defined?(::Rails::Server) && Rails.env == 'development'
    host = ''
    subdomain = 'slack-code-reviews'
    while (host =~ /#{subdomain}/).blank?
      Localtunnel::Client.start(port: 3000, subdomain: subdomain)
      host = URI.parse(Localtunnel::Client.url).host
      puts "Local tunnel: #{Localtunnel::Client.url}"
      Localtunnel::Client.stop if (host =~ /#{subdomain}/).blank?
    end
    Rails.application.config.hosts << host
  end
end
