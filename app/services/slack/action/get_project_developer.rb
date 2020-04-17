# frozen_string_literal: true

module Slack
  module Action
    # Displays to the command user if a developer has been assigned to the
    # project
    class GetProjectDeveloper < Slack::AbstractAction
      def initialize(slack_workspace, project, developer)
        super(slack_workspace)

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
