# frozen_string_literal: true

module Slack
  module Action
    # Displays a list of the projects in the slack workspace with their
    # associated developers
    class ListProjectDeveloper < Slack::AbstractAction
      def initialize(slack_workspace)
        super(slack_workspace)

        lines = []
        projects = Project.where(slack_workspace: @slack_workspace)
        projects.each do |project|
          lines += project_content(project)
        end

        @text = lines.join("\n")
        @text = 'No projects added yet.' if projects.empty?
      end

    private

      def project_content(project)
        lines = []
        lines << "#{project.name}:"
        if project.developers.empty?
          lines << '    - No developers added yet.'
        else
          project.developers.each do |developer|
            lines << "    - <#{developer.name}>"
          end
        end

        lines
      end
    end
  end
end
