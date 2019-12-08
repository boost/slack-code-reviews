# frozen_string_literal: true

module Slack
  module Action
    # removes a project by its name
    class RemoveProject < Slack::AbstractAction
      def initialize(slack_workspace, project_name)
        super(slack_workspace)
        project = @slack_workspace.projects.find_by(name: project_name)
        if project
          project.destroy
          @text = "Project \"#{project.name}\" removed."
        else
          @text = "Project \"#{project_name}\" not found."
        end
      end
    end
  end
end
