# frozen_string_literal: true

module Slack
  module Action
    # This is the main feature of this application
    # It is called when a user wants to create a code review and pick randomly
    # or not code reviewers. In any case the code review is saved to update the
    # developers place in the queue
    class AddCodeReview < Slack::AbstractAction
      REQUIRED_NUMBER_OF_REVIEWERS = 2
      PREFERED_NUMBER_OF_REVIEWERS_IN_PROJECT = 1

      attr_accessor :cr

      def initialize(
        slack_workspace, urls, requester, given_reviewers,
        channel_id, note
      )
        super(slack_workspace)

        reviewers = given_reviewers

        unless reviewers.count == REQUIRED_NUMBER_OF_REVIEWERS
          reviewers += pick_reviewers_in_project(reviewers, requester)
          reviewers += pick_external_reviewers(reviewers, requester)
        end

        create_code_review(
          urls, reviewers, given_reviewers, requester, channel_id, note
        )
      rescue ActiveRecord::RecordNotFound => e
        @visibility = :ephemeral
        @text = e.message
      end

    private

      def create_code_review(
        urls, reviewers, _given_reviewers, requester, channel_id, note
      )
        @cr = CodeReview.create(
          slack_workspace: @slack_workspace,
          urls: urls,
          developers: reviewers,
          requester: requester,
          channel_id: channel_id,
          note: note
        )

        @visibility = :in_channel
        @text = @cr.slack_request
      end

      def pick_reviewers_in_project(reviewers, requester)
        return [] if requester.project.nil?

        reviewers_in_project = reviewers.count do |reviewer|
          reviewer.project == requester.project
        end
        to_take = PREFERED_NUMBER_OF_REVIEWERS_IN_PROJECT - reviewers_in_project

        # developers part of the project but not given by the user
        @slack_workspace.developers.queue
                        .where.not(id: reviewers + [requester])
                        .where(project: requester.project)
                        .limit(to_take)
      end

      def pick_external_reviewers(reviewers, requester)
        to_take = REQUIRED_NUMBER_OF_REVIEWERS - reviewers.length

        Developer
          .queue
          .where.not(id: reviewers + [requester])
          .where(slack_workspace: @slack_workspace)
          .limit(to_take)
      end
    end
  end
end
