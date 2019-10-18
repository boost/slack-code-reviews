# frozen_string_literal: true

module Slack
  module Action
    class AddProject < Slack::AbstractAction
      def initialize(slack_workspace, project_name)
        super(slack_workspace)
        project = Project.find_by(slack_workspace: @slack_workspace, name: project_name)
        if project.blank?
          project = Project.create(slack_workspace: @slack_workspace, name: project_name)
          @text = "Project \"#{project.name}\" added."
        else
          @text = "Project \"#{project.name}\" already existing."
        end
      end
    end
  end
end
