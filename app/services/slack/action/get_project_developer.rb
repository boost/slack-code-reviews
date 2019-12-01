# frozen_string_literal: true

module Slack
  module Action
    class GetProjectDeveloper < Slack::AbstractAction
      def initialize(slack_workspace, project_name, developer_name)
        super(slack_workspace)

        project = Project.find_by(slack_workspace: @slack_workspace, name: project_name)
        developer = Developer.find_by(slack_workspace: @slack_workspace, name: developer_name)
        if project && developer&.project == project
          @text = "#{project.name} - #{developer.name} exists."
        else
          developer_name = developer ? "<#{developer.name}>" : "\"#{developer_name}\""
          @text = "Could not find developer #{developer_name} in project \"#{project_name}\"."
        end
      end
    end
  end
end
