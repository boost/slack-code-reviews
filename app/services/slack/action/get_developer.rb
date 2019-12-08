# frozen_string_literal: true

module Slack
  module Action
    # Displays to the user if the developer exists or not
    class GetDeveloper < Slack::AbstractAction
      def initialize(slack_workspace, developer_name)
        super(slack_workspace)

        developer = @slack_workspace.developers.find_by(name: developer_name)
        @text = text(developer, developer_name)
      end

    private

      def text(developer, developer_name)
        if developer
          "<#{developer.name}> exists."
        else
          "Developer \"#{developer_name}\" not found."
        end
      end
    end
  end
end
