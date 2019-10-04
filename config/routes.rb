# frozen_string_literal: true

Rails.application.routes.draw do
  root 'slack#create'
  post '/slack', to: 'slack#create'

  get  '/*path', to: 'slack#error'
  post '/*path', to: 'slack#error'
end
