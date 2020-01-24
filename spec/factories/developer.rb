# frozen_string_literal: true

FactoryBot.define do
  factory :developer do
    association :project

    name       { Faker::Name.name }
    slack_id   { Faker::Alphanumeric.alphanumeric(number: 9).upcase }
    avatar_url { Faker::Internet.url host: 'github.com/profle' + '.png' }

    before :create do |developer|
      Developer.skip_callback(:create, :before, :enrich_from_api)
      if developer.slack_workspace.nil?
        developer.slack_workspace = SlackWorkspace.first || create(:slack_workspace)
      end
    end

    after :create do
      Developer.set_callback(:create, :before, :enrich_from_api)
    end
  end
end
