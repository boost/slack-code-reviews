# frozen_string_literal: true

module Slack
  module Action
    # It assigns a developer to a project if the developer and the project are
    # found, if not, returns an error message
    class AddProjectDeveloper < Slack::AbstractAction
      def initialize(slack_workspace, project, developer)
        super(slack_workspace)

        if project.present? && developer.present?
          developer.update(project: project)
          @text = "#{developer.tag} assigned to #{project.name}."
        else
          @visibility = :ephemeral
          @text = err_message(project, developer, project_name, developer_tag)
        end
      end

      def err_message(project, developer)
        lines = []
        lines << "Could not find the project \"#{project.name}\"." if project.blank?
        lines << "Could not find the developer \"#{developer.tag}\"." if developer.blank?

        lines.join("\n")
      end
    end
  end
end
