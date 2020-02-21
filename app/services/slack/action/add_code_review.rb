# frozen_string_literal: true

module Slack
  module Action
    # This is the main feature of this application
    # It is called when a user wants to create a code review and pick randomly
    # or not code reviewers. In any case the code review is saved to update the
    # developers place in the queue
    class AddCodeReview < Slack::AbstractAction
      PREFERED_NUMBER_OF_REVIEWERS_IN_PROJECT = 1

      attr_accessor :url, :chosen_reviewers, :picked_reviewers, :requester

      def initialize(slack_workspace, url, requester, given_reviewers_tags)
        super(slack_workspace)

        given_reviewers = pick_reviewers_by_tags(given_reviewers_tags)
        reviewers = given_reviewers

        reviewers += pick_reviewers_in_project(reviewers, requester)
        reviewers += project.pick_external_reviewers_by_project(reviewers, requester)

        create_code_review(url, reviewers, given_reviewers, requester)
      rescue ActiveRecord::RecordNotFound => e
        @visibility = :ephemeral
        @text = e.message
      end

    private

      def create_code_review(url, reviewers, given_reviewers, requester)
        CodeReview.create(
          slack_workspace: @slack_workspace, url: url, developers: reviewers
        )

        @url = url
        @visibility = :in_channel
        @requester = requester
        @chosen_reviewers = given_reviewers
        @picked_reviewers = reviewers - given_reviewers
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

      def pick_reviewers_by_tags(tags)
        return [] if tags.empty?

        tags.map do |tag|
          @slack_workspace.developers.find_by_tag(tag)
        end.compact
      end
    end
  end
end
