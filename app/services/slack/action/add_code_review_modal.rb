# frozen_string_literal: true

module Slack
  module Action
    # This is the main feature of this application
    # It is called when a user wants to create a code review and pick randomly
    # or not code reviewers. In any case the code review is saved to update the
    # developers place in the queue
    class AddCodeReviewModal < Slack::Action::AddCodeReview
      attr_accessor :reviewers, :dev_queue

      def respond_to_command(payload, _params)
        response = Slack::Api::ViewsOpen.new(payload).call
        handle_response(response)
      end

      def handle_response(response)
        Rails.logger.info("handle response!! #{response}")
      end

      def view
        "#{self.class.to_s.singularize.underscore}.json"
      end

    private

      def create_code_review(url, reviewers, _given_reviewers, requester)
        CodeReview.create(
          slack_workspace: @slack_workspace, url: url, developers: reviewers,
          draft: true
        )

        @url = url
        @visibility = :in_channel
        @requester = requester

        @dev_queue = Developer.queue
        @reviewers = reviewers
      end
    end
  end
end
