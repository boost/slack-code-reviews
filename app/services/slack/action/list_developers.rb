# frozen_string_literal: true

module Slack
  module Action
    class ListDevelopers < Slack::AbstractAction
      def initialize(slack_workspace)
        super(slack_workspace)

        developers = Developer.where(slack_workspace: @slack_workspace).map do |developer|
          "    - <#{developer.name}>"
        end

        @text = (['Developer list:'] + developers).join("\n")
        @text = 'No developers added yet.' if developers.empty?
      end
    end
  end
end
