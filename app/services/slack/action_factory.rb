# frozen_string_literal: true

module Slack
  class ActionFactory
    def self.build(options)
      return Slack::Action::Help.new(options.help) if options.help.present?

      return developer_action(options) if options.resource == 'developer'
      return project_action(options) if options.resource == 'project'
      return code_review_action(options) if options.resource == 'code-review'
    end

    def call
      @action
    end

  private

    class << self
      def developer_action(options)
        case options.crud
        when 'add'
          return Slack::Action::AddDeveloper.new(options.slack_workspace, options.developer)
        when 'remove'
          return Slack::Action::RemoveDeveloper.new(options.slack_workspace, options.developer)
        when 'list'
          return Slack::Action::ListDevelopers.new(options.slack_workspace)
        end
      end

      def project_action(options)
        case options.crud
        when 'add'
          return Slack::Action::AddProject.new(options.slack_workspace, options.project)
        when 'remove'
          return Slack::Action::RemoveProject.new(options.slack_workspace, options.project)
        when 'list'
          return Slack::Action::ListProjects.new(options.slack_workspace)
        end
      end

      def code_review_action(options)
        case options.crud
        when 'add'
          return Slack::Action::CreateCodeReview.new(
            options.slack_workspace,
            options.url,
            options.requester,
            options.reviewers
          )
        end
      end
    end
  end
end
