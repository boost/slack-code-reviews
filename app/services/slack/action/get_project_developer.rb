# frozen_string_literal: true

module Slack
  module Action
    # Displays to the command user if a developer has been assigned to the
    # project
    class GetProjectDeveloper < Slack::AbstractAction
      def initialize(slack_workspace, project_name, developer_name)
        super(slack_workspace)

        project = @slack_workspace.projects.find_by(name: project_name)
        developer = @slack_workspace.developers.find_by(name: developer_name)
        if project && developer&.project == project
          @text = "#{project.name} - #{developer.name} exists."
        else
          @text = 'Could not find developer '
          @text += developer_name(developer, developer_name)
          @text += " in project \"#{project_name}\"."
        end
      end

    private

      def developer_name(developer, developer_name)
        developer ? "<#{developer.name}>" : "\"#{developer_name}\""
      end
    end
  end
end
