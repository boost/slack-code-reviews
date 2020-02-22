# frozen_string_literal: true

module Slack
  # base class for the different interactions in Slack
  # see the interaction folder
  # https://api.slack.com/reference/interaction-payloads/block-actions
  class AbstractInteraction
    attr_accessor :view, :visibility, :cr

    def initialize(payload)
      @payload = payload
      extract_info
    end

  private

    def extract_info
      @view_id = @payload['view']['id']
    end

    def field_value(field)
      block_id = "#{field}_block"
      action_id = "#{field}_action"
      @payload['view']['state']['values'][block_id][action_id]['value']
    end
  end
end
