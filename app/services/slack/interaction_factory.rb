# frozen_string_literal: true

module Slack
  # base class for the different interactions in Slack
  # see the interaction folder
  # https://api.slack.com/reference/interaction-payloads/block-actions
  class InteractionFactory
    def initialize(payload)
      @payload = JSON.parse(payload)
    end

    def call
      case @payload['type']
      when 'block_actions'
        Slack::Interaction::BlockActions.new(@payload)
      when 'view_submission'
        Slack::Interaction::ViewSubmission.new(@payload)
      else Rails.logger.debug("unknown payload type #{@payload['type']}")
      end
    end
  end
end
