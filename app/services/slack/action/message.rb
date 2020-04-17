# frozen_string_literal: true

module Slack
  module Action
    # displays to the user the manual for the command
    class Message < Slack::AbstractAction
      def initialize(message)
        @text = message
      end
    end
  end
end
