# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    association :slack_workspace

    name { Faker::Company.name }

    before :create do |project|
      if project.slack_workspace.nil?
        project.slack_workspace = SlackWorkspace.first || create(:slack_workspace)
      end
    end
  end
end
