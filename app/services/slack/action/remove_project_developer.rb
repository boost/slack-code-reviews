# frozen_string_literal: true

module Slack
  module Action
    # Removes a developer from a project, both are found by their name
    class RemoveProjectDeveloper < Slack::AbstractAction
      def initialize(slack_workspace, project_name, developer_name)
        super(slack_workspace)

        project = @slack_workspace.projects.find_by(name: project_name)
        developer = @slack_workspace.developers.find_by(name: developer_name)
        if project && developer&.project == project
          project.developers.delete(developer)
          @text = "<#{developer.name}> removed from project #{project.name}."
        else

          @text = err_message(project, developer, project_name, developer_name)
        end
      end

    private

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
