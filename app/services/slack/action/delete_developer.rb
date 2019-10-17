# frozen_string_literal: true

module Slack
  module Action
    class DeleteDeveloper < Slack::AbstractAction
      def initialize(args)
        super(args)
        Developer.find_by(slack_workspace: @slack_workspace, name: args.delete_developer).destroy
        @text = "Developer <#{args.delete_developer}> deleted"
      end
    end
  end
end
