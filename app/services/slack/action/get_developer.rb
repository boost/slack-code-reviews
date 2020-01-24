# frozen_string_literal: true

module Slack
  module Action
    # Displays to the user if the developer exists or not
    class GetDeveloper < Slack::AbstractAction
      def initialize(slack_workspace, developer_tag)
        super(slack_workspace)

        developer = @slack_workspace.developers.find_by_tag(developer_tag)
        @text = assign_text(developer, developer_tag)
      end

    private

      def assign_text(developer, developer_tag)
        if developer
          if developer.away?
            "#{developer.tag} exists but is away."
          else
            "#{developer.tag} exists and is available."
          end
        else
          "Developer \"#{developer_tag}\" not found."
        end
      end
    end
  end
end
