# frozen_string_literal: true

module Slack
  module Action
    # Remove a developer by its name
    class RemoveDeveloper < Slack::AbstractAction
      def initialize(slack_workspace, developer_tag)
        super(slack_workspace)
        developer = @slack_workspace.developers.find_by_tag(developer_tag)
        if developer
          developer.destroy
          @text = "Developer #{developer.tag} removed."
        else
          @text = "Developer \"#{developer_tag}\" not found."
        end
      end
    end
  end
end
