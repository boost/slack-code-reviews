# frozen_string_literal: true

module Slack
  module Action
    class AddDeveloper < Slack::AbstractAction
      def initialize(options)
        super(options)
        Developer.find_or_create_by(slack_workspace: @slack_workspace, name: options.developer)
        @text = "Developer <#{options.developer}> added"
      end
    end
  end
end
