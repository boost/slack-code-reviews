# frozen_string_literal: true

module Slack
  module Action
    class ListProjects < Slack::AbstractAction
      def initialize(slack_workspace)
        super(slack_workspace)

        projects = Project.where(slack_workspace: @slack_workspace).map do |developer|
          "    - <#{developer.name}>"
        end

        @text = (['Projects list:'] + projects).join("\n")
        @text = 'No projects added yet.' if projects.empty?
      end
    end
  end
end
