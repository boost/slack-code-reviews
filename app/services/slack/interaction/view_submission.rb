# frozen_string_literal: true

module Slack
  module Interaction
    class ViewSubmission < Slack::AbstractInteraction
      def initialize(payload)
        super(payload)
      end

      def save_state
        @cr = CodeReview.find_by(view_id: @view_id)
        @cr.update(url: @url1, note: @note)
        @visibility = :ephemeral
        @view = 'slack/action/partials/_add_code_review_blocks.json'
      end

      def answer_to_interaction(view_string)
        Rails.logger.debug(view_string)
        # binding.pry
        response = Slack::Api::ChatPostMessage.new(
          channel: 'DH1H1ST2Q',
          blocks: view_string
        ).call
        Rails.logger.debug('ChatPostMessage response:')
        Rails.logger.debug(response)
      end

    private

      def extract_info
        super
        @url1 = extract_block_value('url_1_block')
        @note = extract_block_value('note_block')
      end
    end
  end
end
