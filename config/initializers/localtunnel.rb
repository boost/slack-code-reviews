# frozen_string_literal: true

if Rails.env == 'development'
  Localtunnel::Client.start(port: 3000, subdomain: 'slack-code-reviews')
  puts "Local tunnel: #{Localtunnel::Client.url}"
  Rails.application.config.hosts << URI.parse(Localtunnel::Client.url).host
end
