# frozen_string_literal: true

module Slack
  # This action factory takes the arguments from the ArgumentParser + some
  # extra information for choosing a Slack Action to execute
  class ActionFactory
    def self.build(options)
      return Slack::Action::Message.new(options.message) if options.message

      case options.object
      when 'developer'         then developer_action(options)
      when 'project'           then project_action(options)
      when 'project-developer' then project_developer_action(options)
      when 'code-review'       then code_review_action(options)
      else Slack::Action::Message.new(options.message)
      end
    end

    def call
      @action
    end

    class << self
      def developer_action(options)
        case options.action
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
        when 'delete'
          Slack::Action::RemoveDeveloper.new(
            options.slack_workspace, options.developer
          )
        when 'list'
          Slack::Action::ListDevelopers.new(options.slack_workspace)
        end
      end

      def project_action(options)
        case options.action
        when 'get'
          Slack::Action::GetProject.new(
            options.slack_workspace, options.project
          )
        when 'add'
          Slack::Action::AddProject.new(
            options.slack_workspace, options.project
          )
        when 'delete'
          Slack::Action::RemoveProject.new(
            options.slack_workspace, options.project
          )
        when 'list'
          Slack::Action::ListProjects.new(options.slack_workspace)
        end
      end

      def project_developer_action(options)
        case options.action
        when 'get'
          Slack::Action::GetProjectDeveloper.new(
            options.slack_workspace, options.project, options.developer
          )
        when 'add'
          Slack::Action::AddProjectDeveloper.new(
            options.slack_workspace, options.project, options.developer
          )
        when 'delete'
          Slack::Action::RemoveProjectDeveloper.new(
            options.slack_workspace, options.project, options.developer
          )
        when 'list'
          Slack::Action::ListProjectDeveloper.new(options.slack_workspace)
        end
      end

      def code_review_action(options)
        case options.action
        when 'get'
          Slack::Action::GetCodeReview.new(
            options.slack_workspace, options.urls
          )
        when 'add'
          if options.modal
            Slack::Action::AddCodeReviewModal.new(
              options.slack_workspace,
              options.urls,
              options.requester,
              options.reviewers,
              options.channel_id,
              options.note
            )
          else
            Slack::Action::AddCodeReview.new(
              options.slack_workspace,
              options.urls,
              options.requester,
              options.reviewers,
              options.channel_id,
              options.note
            )
          end
        when 'delete'
          Slack::Action::RemoveCodeReview.new(
            options.slack_workspace, options.urls
          )
        when 'list'
          Slack::Action::ListCodeReviews.new(options.slack_workspace)
        end
      end
    end
  end
end
