# frozen_string_literal: true

module Slack
  module Action
    # This is the main feature of this application
    # It is called when a user wants to create a code review and pick randomly
    # or not code reviewers. In any case the code review is saved to update the
    # developers place in the queue
    class AddCodeReviewModal < Slack::Action::AddCodeReview
      attr_accessor :reviewers, :dev_queue

      def respond_to_command(view_string, params)
        response = Slack::Api::ViewsOpen.new(
          trigger_id: params[:trigger_id],
          view: view_string
        ).call
        handle_response(response)
      end

      def handle_response(response)
        Rails.logger.debug(response)
        return unless response['ok']

        @cr.update(view_id: response['view']['id'])
      end

      def view
        "#{self.class.to_s.singularize.underscore}.json"
      end

    private

      def create_code_review(
        urls, reviewers, _given_reviewers, requester, channel_id, note
      )
        @cr = CodeReview.create(
          slack_workspace: @slack_workspace,
          urls: urls.map { |url| Url.new(url: url) },
          reviewers: reviewers,
          requester: requester,
          draft: true,
          channel_id: channel_id,
          note: note
        )

        @dev_queue = Developer.queue.where.not(id: requester)
      end
    end
  end
end
