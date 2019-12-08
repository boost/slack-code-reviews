# frozen_string_literal: true

module Slack
  module Action
    # displays to the user the manual for the command
    class Help < Slack::AbstractAction
      def initialize(help_text)
        @text = help_text
      end
    end
  end
end
