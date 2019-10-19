# frozen_string_literal: true

module Slack
  module Action
    class RemoveProjectDeveloper < Slack::AbstractAction
      def initialize(slack_workspace, project_name)
        super(slack_workspace)
        project = Project.find_by(slack_workspace: @slack_workspace, name: project_name)
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
