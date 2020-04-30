# frozen_string_literal: true

module Slack
  module Action
    # Adds a project to assign developers to it in the future
    class AddProject < Slack::AbstractAction
      def initialize(slack_workspace, project)
        super(slack_workspace)

        project.save
        @text = "Project \"#{project.name}\" added."
      end
    end
  end
end
