# frozen_string_literal: true

Rails.application.routes.draw do
  post '/slack-api/slash-command', to: 'slack#slash_command'
  post '/slack-api/interaction', to: 'slack#interaction'

  get  '/*path', to: 'slack#error'
  post '/*path', to: 'slack#error'
end
