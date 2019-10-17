# frozen_string_literal: true

module Slack
  module Action
    class DeleteDeveloper < Slack::AbstractAction
      def initialize(options)
        super(options)
        Developer.find_by(slack_workspace: @slack_workspace, name: options.developer).destroy
        @text = "Developer <#{options.developer}> deleted"
      end
    end
  end
end
