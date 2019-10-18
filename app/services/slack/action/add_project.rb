# frozen_string_literal: true

module Slack
  module Action
    class AddProject < Slack::AbstractAction
      def initialize(slack_workspace, project_name)
        super(slack_workspace)
        Project.find_or_create_by(slack_workspace: @slack_workspace, name: project_name)
        @text = "Project <#{project_name}> added"
      end
    end
  end
end
