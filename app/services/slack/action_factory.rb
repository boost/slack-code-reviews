# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength
module Slack
  # This action factory takes the arguments from the ArgumentParser + some
  # extra information for choosing a Slack Action to execute
  class ActionFactory
    def self.build(options)
      return Slack::Action::Help.new(options.help) if options.show_help

      return developer_action(options) if options.resource == 'developer'
      return project_action(options) if options.resource == 'project'
      if options.resource == 'project-developer'
        return project_developer_action(options)
      end
      return code_review_action(options) if options.resource == 'code-review'

      Slack::Action::Help.new(options.help)
    end

    def call
      @action
    end

    class << self
      def developer_action(options)
        case options.crud
        when 'get'
          Slack::Action::GetDeveloper.new(
            options.slack_workspace, options.developer
          )
        when 'set'
          Slack::Action::SetDeveloper.new(
            options.slack_workspace, options.developer, options.attributes
          )
        when 'add'
          Slack::Action::AddDeveloper.new(
            options.slack_workspace, options.developer
          )
        when 'remove'
          Slack::Action::RemoveDeveloper.new(
            options.slack_workspace, options.developer
          )
        when 'list'
          Slack::Action::ListDevelopers.new(options.slack_workspace)
        else
          Slack::Action::Help.new(options.help)
        end
      end

      def project_action(options)
        case options.crud
        when 'get'
          Slack::Action::GetProject.new(
            options.slack_workspace, options.project
          )
        when 'add'
          Slack::Action::AddProject.new(
            options.slack_workspace, options.project
          )
        when 'remove'
          Slack::Action::RemoveProject.new(
            options.slack_workspace, options.project
          )
        when 'list'
          Slack::Action::ListProjects.new(options.slack_workspace)
        else
          Slack::Action::Help.new(options.help)
        end
      end

      def project_developer_action(options)
        case options.crud
        when 'get'
          Slack::Action::GetProjectDeveloper.new(
            options.slack_workspace, options.project, options.developer
          )
        when 'add'
          Slack::Action::AddProjectDeveloper.new(
            options.slack_workspace, options.project, options.developer
          )
        when 'remove'
          Slack::Action::RemoveProjectDeveloper.new(
            options.slack_workspace, options.project, options.developer
          )
        when 'list'
          Slack::Action::ListProjectDeveloper.new(options.slack_workspace)
        else
          Slack::Action::Help.new(options.help)
        end
      end

      def code_review_action(options)
        case options.crud
        when 'get'
          Slack::Action::GetCodeReview.new(options.slack_workspace, options.url)
        when 'add'
          Slack::Action::AddCodeReview.new(
            options.slack_workspace,
            options.url,
            options.requester,
            options.reviewers
          )
        when 'remove'
          Slack::Action::RemoveCodeReview.new(
            options.slack_workspace, options.url
          )
        when 'list'
          Slack::Action::ListCodeReviews.new(options.slack_workspace)
        else
          Slack::Action::Help.new(options.help)
        end
      end
    end
  end
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/MethodLength
