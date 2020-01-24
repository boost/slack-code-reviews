# frozen_string_literal: true

FactoryBot.define do
  factory :code_review do
    association :slack_workspace

    url { Faker::Internet.url host: 'github.com/boost' }
  end
end
