# frozen_string_literal: true

module Slack
  module Action
    # Displays to the command user if a developer has been assigned to the
    # project
    class GetProjectDeveloper < Slack::AbstractAction
      def initialize(slack_workspace, project_name, developer_tag)
        super(slack_workspace)

        project = @slack_workspace.projects.find_by(name: project_name)
        developer = @slack_workspace.developers.find_by_tag(developer_tag)
        if project && developer&.project == project
          @text = "#{project.name} - #{developer.tag} exists."
        else
          @text = 'Could not find developer '
          @text += developer_tag
          @text += " in project \"#{project_name}\"."
        end
      end
    end
  end
end
