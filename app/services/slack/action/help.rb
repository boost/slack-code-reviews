# frozen_string_literal: true

module Slack
  module Action
    class Help < Slack::AbstractAction
      def initialize(args)
        super(args)
        @text = args.help
      end
    end
  end
end
