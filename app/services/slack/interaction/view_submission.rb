# frozen_string_literal: true

module Slack
  module Interaction
    class ViewSubmission < Slack::AbstractInteraction
      attr_accessor :text

      def save_state
        @cr = CodeReview.find_by(view_id: @view_id)
        @cr.urls.destroy_all
        @cr.update(urls: @urls, note: @note, draft: false)
        @view = 'slack/action/simple_message.json'

        @visibility = :ephemeral
        @text = @cr.slack_request
      end

      def answer_to_interaction(view_string)
        Rails.logger.debug("view_string: #{view_string}")

        response = Slack::Api::ChatPostMessage.new(
          channel: @cr.channel_id,
          text: text,
          username: 'Code Reviews',
          token: ENV['SLACK_BOT_USER_OAUTH_ACCESS_TOKEN']
        ).call
        Rails.logger.debug("ChatPostMessage response: #{response}")
      end

    private

      def extract_info
        super
        @urls = field_value('urls').split.map { |url| Url.new(url: url) }
        @note = field_value('note')
      end
    end
  end
end
