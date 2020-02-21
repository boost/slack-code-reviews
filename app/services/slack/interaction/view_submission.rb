# frozen_string_literal: true

module Slack
  module Interaction
    class ViewSubmission < Slack::AbstractInteraction
      attr_accessor :text

      def save_state
        @cr = CodeReview.find_by(view_id: @view_id)
        @cr.urls.destroy_all
        @cr.update(urls: [Url.new(url: @url1)], note: @note, draft: false)
        @view = 'slack/action/simple_message.json'

        @visibility = :ephemeral
        note = @cr.note.nil? ? '' : "[#{@cr.note}] "

        @text = "#{note}#{cr.reviewers.map(&:tag).join(', ')}, could you review"
        @text += if @cr.urls.count == 1
                   " #{@cr.urls.first.slack_url}"
                 else
                   ":\n- #{@cr.urls.map(&:slack_url).join("\n- ")}"
                 end
      end

      def answer_to_interaction(view_string)
        Rails.logger.debug("view_string: #{view_string}")
        # binding.pry
        response = Slack::Api::ChatPostMessage.new(
          channel: 'DH1H1ST2Q',
          text: text
        ).call
        Rails.logger.debug("ChatPostMessage response: #{response}")
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
