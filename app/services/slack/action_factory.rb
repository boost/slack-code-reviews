# frozen_string_literal: true

module Slack
  class ActionFactory
    def initialize(options)
      if options.help.present?
        @action = Slack::Action::Help.new(options.help)
      elsif options.crud == 'add' && options.resource == 'developer'
        @action = Slack::Action::AddDeveloper.new(options.slack_workspace, options.developer)
      elsif options.crud == 'remove' && options.resource == 'developer'
        @action = Slack::Action::DeleteDeveloper.new(options.slack_workspace, options.developer)
      elsif options.crud == 'list' && options.resource == 'developer'
        @action = Slack::Action::ListDevelopers.new(options.slack_workspace)
      elsif options.crud == 'add' && options.resource == 'code-review'
        @action = Slack::Action::CreateCodeReview.new(
          options.slack_workspace,
          options.url,
          options.requester,
          options.reviewers
        )
      else
        raise 'Wrong arguments'
      end
    end

    def call
      @action
    end
  end
end
