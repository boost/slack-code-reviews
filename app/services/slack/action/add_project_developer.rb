# frozen_string_literal: true

module Slack
  module Action
    # It assigns a developer to a project if the developer and the project are
    # found, if not, returns an error message
    class AddProjectDeveloper < Slack::AbstractAction
      def initialize(slack_workspace, project_name, developer_name)
        super(slack_workspace)
        developer = @slack_workspace.developers.find_by(name: developer_name)

        project = @slack_workspace.projects.find_by(name: project_name)

        if project.present? && developer.present?
          developer.update(project: project)
          @text = "<#{developer_name}> assigned to #{project_name}."
        else
          @visibility = :ephemeral
          @text = err_message(project, developer, project_name, developer_name)
        end
      end

      def err_message(project, developer, project_name, developer_name)
        lines = []
        if project.blank?
          lines << "Could not find the project \"#{project_name}\"."
        end

        if developer.blank?
          lines << "Could not find the developer \"#{developer_name}\"."
        end

        lines.join("\n")
      end
    end
  end
end
