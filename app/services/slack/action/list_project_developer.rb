# frozen_string_literal: true

module Slack
  module Action
    class ListProjectDeveloper < Slack::AbstractAction
      def initialize(slack_workspace)
        super(slack_workspace)

        lines = []
        projects = Project.where(slack_workspace: @slack_workspace)
        projects.each do |project|
          lines << "#{project.name}:"
          if project.developers.empty?
            lines << "    - No developers added yet."
          else
            project.developers.each { |developer| lines << "    - <#{developer.name}>" }
          end
        end

        @text = lines.join("\n")
        @text = 'No projects added yet.' if projects.empty?
      end
    end
  end
end
