# frozen_string_literal: true

module Slack
  module Action
    class GetDeveloper < Slack::AbstractAction
      def initialize(slack_workspace, developer_name)
        super(slack_workspace)

        developer = Developer.find_by(slack_workspace: @slack_workspace, name: developer_name)
        if developer
          @text = "<#{developer.name}> exists."
        else
          @text = "Developer \"#{developer_name}\" not found."
        end
      end
    end
  end
end
