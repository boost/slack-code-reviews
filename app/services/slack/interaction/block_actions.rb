# frozen_string_literal: true

module Slack
  module Interaction
    class BlockActions < Slack::AbstractInteraction
      def initialize(payload)
        super(payload)
      end
    end
  end
end
