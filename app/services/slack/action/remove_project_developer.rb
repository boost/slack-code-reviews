# frozen_string_literal: true

module Slack
  module Action
    # Removes a developer from a project, both are found by their name
    class RemoveProjectDeveloper < Slack::AbstractAction
      def initialize(slack_workspace, project, developer)
        super(slack_workspace)

        if project && developer&.project == project
          project.developers.delete(developer)
          @text = "#{developer.tag} removed from project #{project.name}."
        else

          @text = err_message(project, developer, project_name, developer_tag)
        end
      end

    private

      def err_message(project, developer, project_name, developer_tag)
        lines = []
        lines << "Could not find the project \"#{project_name}\"." if project.blank?
        lines << "Could not find the developer \"#{developer_tag}\"." if developer.blank?

        lines.join("\n")
      end
    end
  end
end
