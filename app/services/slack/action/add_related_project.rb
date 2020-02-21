# frozen_string_literal: true

module Slack
  module Action
    # Adds a project to another project so that they are related for code reviews
    class AddRelatedProject < Slack::AbstractAction
      def initialize(slack_workspace, project_name, related_project_name)
        super(slack_workspace)
        project = @slack_workspace.projects.find_by(name: project_name)
        related_project = @slack_workspace.projects.find_by(name: related_project_name)

        project.related_project_id = related_project.id
        project.save!

        @text = 'Projects are now related.'
      end
    end
  end
end
