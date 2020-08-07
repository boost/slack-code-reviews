# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    association :slack_workspace

    name { Faker::Company.name }

    before :create do |project|
      project.slack_workspace = SlackWorkspace.first || create(:slack_workspace) if project.slack_workspace.nil?
    end
  end
end
