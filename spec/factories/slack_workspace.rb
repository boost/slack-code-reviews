# frozen_string_literal: true

FactoryBot.define do
  factory :slack_workspace do
    slack_workspace_id { Faker::Alphanumeric.alphanumeric(number: 9).upcase }
  end
end
