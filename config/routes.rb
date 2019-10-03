# frozen_string_literal: true

Rails.application.routes.draw do
  root 'slack#create'
  post '/slack', to: 'slack#create'
end
