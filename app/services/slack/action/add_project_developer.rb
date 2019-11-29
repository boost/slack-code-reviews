# frozen_string_literal: true

module Slack
  module Action
    class AddProjectDeveloper < Slack::AbstractAction
      def initialize(slack_workspace, developer_name, project_name)
        super(slack_workspace)

        developer = Developer.find_by(slack_workspace: @slack_workspace, name: developer_name)

        project = Project.find_by(slack_workspace: @slack_workspace, name: project_name)

        developer.update(project: project)

        @text = "<#{developer_name}> assigned to #{project_name}"
      rescue ActiveRecord::RecordNotFound => e
        @visibility = :ephemeral
        @text = e.message
      end
    end
  end
end
