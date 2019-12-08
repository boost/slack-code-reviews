# frozen_string_literal: true

module Slack
  module Action
    # Simply returns to the command user if the project exists
    class GetProject < Slack::AbstractAction
      def initialize(slack_workspace, project_name)
        super(slack_workspace)

        project = @slack_workspace.projects.find_by(name: project_name)
        @text = text(project, project_name)
      end

    private

      def text(project, project_name)
        if project
          "\"#{project.name}\" exists."
        else
          "Project \"#{project_name}\" not found."
        end
      end
    end
  end
end
