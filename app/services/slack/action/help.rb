# frozen_string_literal: true

module Slack
  module Action
    class Help < Slack::AbstractAction
      def initialize(help_text)
        @text = help_text
      end
    end
  end
end
