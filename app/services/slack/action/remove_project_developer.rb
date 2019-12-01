# frozen_string_literal: true

module Slack
  module Action
    class RemoveProjectDeveloper < Slack::AbstractAction
      def initialize(slack_workspace, project_name, developer_name)
        super(slack_workspace)

        project = Project.find_by(slack_workspace: @slack_workspace, name: project_name)
        developer = Developer.find_by(slack_workspace: @slack_workspace, name: developer_name)
        if project && developer&.project == project
          project.developers.delete(developer)
          @text = "Developer <#{developer.name}> removed from project #{project.name}."
        else
          developer_name = developer ? "<#{developer.name}>" : "\"#{developer_name}\""
          @text = "Could not find developer #{developer_name} in project \"#{project_name}\"."
        end
      end
    end
  end
end
