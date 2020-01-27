# frozen_string_literal: true

module Slack
  module Interaction
    # instanciate the right interaction class depending on the payload
    # content
    class Factory
      def initialize(payload)
        @payload = payload
      end

      def call
        case @payload['type']
        when 'block_actions'
        when 'view_submission'
        when 'view_closed'
        end
      end
    end
  end
end
