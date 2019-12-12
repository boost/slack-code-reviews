# frozen_string_literal: true

module Slack
  module Action
    # Displays to the user if the developer exists or not
    class GetDeveloper < Slack::AbstractAction
      def initialize(slack_workspace, developer_tag)
        super(slack_workspace)

        developer = @slack_workspace.developers.find_by_tag(developer_tag)
        @text = text(developer, developer_tag)
      end

    private

      def text(developer, developer_tag)
        if developer
          "#{developer.tag} exists."
        else
          "Developer \"#{developer_tag}\" not found."
        end
      end
    end
  end
end
