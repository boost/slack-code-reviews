# frozen_string_literal: true

module Slack
  module Action
    # Adds a project to assign developers to it in the future
    class AddProject < Slack::AbstractAction
      def initialize(slack_workspace, project_name)
        super(slack_workspace)
        project = @slack_workspace.projects.find_by(name: project_name)

        if project.blank?
          project = create_project(project_name)
          @text = "Project \"#{project.name}\" added."
        else
          @text = "Project \"#{project.name}\" already existing."
        end
      end

    private

      def create_project(project_name)
        Project.create(
          slack_workspace: @slack_workspace, name: project_name
        )
      end
    end
  end
end
