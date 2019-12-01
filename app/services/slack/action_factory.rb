# frozen_string_literal: true

module Slack
  class ActionFactory
    def self.build(options)
      return Slack::Action::Help.new(options.help) if options.show_help

      return developer_action(options) if options.resource == 'developer'
      return project_action(options) if options.resource == 'project'
      return project_developer_action(options) if options.resource == 'project-developer'
      return code_review_action(options) if options.resource == 'code-review'

      return Slack::Action::Help.new(options.help)
    end

    def call
      @action
    end

  private

    class << self
      def developer_action(options)
        case options.crud
        when 'get'
          return Slack::Action::GetDeveloper.new(options.slack_workspace, options.developer)
        when 'add'
          return Slack::Action::AddDeveloper.new(options.slack_workspace, options.developer)
        when 'remove'
          return Slack::Action::RemoveDeveloper.new(options.slack_workspace, options.developer)
        when 'list'
          return Slack::Action::ListDevelopers.new(options.slack_workspace)
        else
          return Slack::Action::Help.new(options.help)
        end
      end

      def project_action(options)
        case options.crud
        when 'get'
          return Slack::Action::GetProject.new(options.slack_workspace, options.project)
        when 'add'
          return Slack::Action::AddProject.new(options.slack_workspace, options.project)
        when 'remove'
          return Slack::Action::RemoveProject.new(options.slack_workspace, options.project)
        when 'list'
          return Slack::Action::ListProjects.new(options.slack_workspace)
        else
          return Slack::Action::Help.new(options.help)
        end
      end

      def project_developer_action(options)
        case options.crud
        when 'get'
          return Slack::Action::GetProjectDeveloper.new(options.slack_workspace, options.project, options.developer)
        when 'add'
          return Slack::Action::AddProjectDeveloper.new(options.slack_workspace, options.project, options.developer)
        when 'remove'
          return Slack::Action::RemoveProjectDeveloper.new(options.slack_workspace, options.project, options.developer)
        when 'list'
          return Slack::Action::ListProjectDeveloper.new(options.slack_workspace)
        else
          return Slack::Action::Help.new(options.help)
        end
      end

      def code_review_action(options)
        case options.crud
        when 'get'
          return Slack::Action::GetCodeReview.new(options.slack_workspace, options.url)
        when 'add'
          return Slack::Action::AddCodeReview.new(
            options.slack_workspace,
            options.url,
            options.requester,
            options.reviewers
          )
        when 'remove'
          return Slack::Action::RemoveCodeReview.new(options.slack_workspace, options.url)
        when 'list'
          return Slack::Action::ListCodeReviews.new(options.slack_workspace)
        else
          return Slack::Action::Help.new(options.help)
        end
      end
    end
  end
end
