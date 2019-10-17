# frozen_string_literal: true

module Slack
  module Action
    class ListDevelopers < Slack::AbstractAction
      def initialize(args)
        super(args)
        developers = Developer.where(slack_workspace: @slack_workspace).map { |d| "    - <#{d.name}>" }
        @text = (['Developer list:'] + developers).join("\n")
        @text = 'No developers added yet.' if developers.empty?
      end
    end
  end
end
