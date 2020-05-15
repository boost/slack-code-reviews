# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}" }

ruby '2.6.5'

gem 'airbrake', '~> 10.0'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'jbuilder', '~> 2.7'
gem 'mysql2', '>= 0.4.4'
gem 'puma', '~> 4.3'
gem 'rails', '~> 6.0.0'
gem 'rest-client', '~> 2.1'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making
# cross-origin AJAX possible
# gem 'rack-cors'

group :test do
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'rubocop-rails'
  gem 'shoulda-matchers'
end

group :development, :test do
  gem 'boost-styles', github: 'boost/boost-styles'
  gem 'pry-byebug', '~> 3.7'
  gem 'pry-rails', '~> 0.3'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 2.1'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
