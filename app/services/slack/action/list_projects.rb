# frozen_string_literal: true

module Slack
  module Action
    # Displays a list of the projects related to the slack workspace
    class ListProjects < Slack::AbstractAction
      def initialize(slack_workspace)
        super(slack_workspace)

        projects = @slack_workspace.projects.map do |project|
          "    - #{project.name}"
        end

        @text = (['Projects list:'] + projects).join("\n")
        @text = 'No projects added yet.' if projects.empty?
      end
    end
  end
end
