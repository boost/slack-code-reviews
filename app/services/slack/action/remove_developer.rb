# frozen_string_literal: true

module Slack
  module Action
    # Remove a developer by its name
    class RemoveDeveloper < Slack::AbstractAction
      def initialize(slack_workspace, developer_name)
        super(slack_workspace)
        developer = @slack_workspace.developers.find_by(name: developer_name)
        if developer
          developer.destroy
          @text = "Developer <#{developer.name}> removed."
        else
          @text = "Developer \"#{developer_name}\" not found."
        end
      end
    end
  end
end
