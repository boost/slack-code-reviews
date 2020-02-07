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

    def extract_block_action_id(block_id)
      blocks = @payload['view']['blocks']
      block = blocks.find { |b| b['block_id'] == block_id }
      if block['element']
        block['element']['action_id']
      elsif block['accessory']
        block['accessory']['action_id']
      end
    end

    def extract_block_value(block_id)
      action_id = extract_block_action_id(block_id)
      @payload['view']['state']['values'][block_id][action_id]['value']
    end
  end
end
