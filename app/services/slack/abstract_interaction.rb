# frozen_string_literal: true

module Slack
  # base class for the different interactions in Slack
  # see the interaction folder
  # https://api.slack.com/reference/interaction-payloads/block-actions
  class AbstractInteraction
    def initialize(payload)
      @payload = JSON.parse(payload)
    end
  end
end
