# frozen_string_literal: true

module Slack
  module Action
    # Shows a simple list of developers
    class ListDevelopers < Slack::AbstractAction
      def initialize(slack_workspace)
        super(slack_workspace)

        developers = @slack_workspace.developers.map do |developer|
          "    - #{developer.tag} (#{developer.away? ? 'away' : 'available'})"
        end

        @text = (['Developer list:'] + developers).join("\n")
        @text = 'No developers added yet.' if developers.empty?
      end
    end
  end
end
