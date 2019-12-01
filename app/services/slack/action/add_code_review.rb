# frozen_string_literal: true

module Slack
  module Action
    class AddCodeReview < Slack::AbstractAction
      REQUIRED_NUMBER_OF_REVIEWERS = 2
      PREFERED_NUMBER_OF_REVIEWERS_IN_PROJECT = 1

      def initialize(slack_workspace, url, requester, given_reviewers_names)
        super(slack_workspace)

        reviewers = pick_reviewers_by_name(given_reviewers_names)

        reviewers += pick_reviewers_in_project(reviewers, requester)
        reviewers += pick_external_reviewers(reviewers, requester)

        create_code_review(url, reviewers)
      rescue ActiveRecord::RecordNotFound => e
        @visibility = :ephemeral
        @text = e.message
      end

    private
      def create_code_review(url, reviewers)
        CodeReview.create(slack_workspace: @slack_workspace, url: url, developers: reviewers)

        @visibility = :in_channel
        @text = "New CR #{url} " + reviewers.map { |reviewer| "<#{reviewer.name}>" }.join(' ')
      end

      def pick_reviewers_in_project(reviewers, requester)
        return [] if requester.project.nil?

        to_take = PREFERED_NUMBER_OF_REVIEWERS_IN_PROJECT -
                  reviewers.count { |reviewer| reviewer.project == requester.project }

        # developers part of the project but not given by the user
        Developer.
          queue.
          where.not(id: reviewers + [requester]).
          where(project: requester.project).
          where(slack_workspace: @slack_workspace).
          limit(to_take)
      end

      def pick_external_reviewers(reviewers, requester)
        to_take = REQUIRED_NUMBER_OF_REVIEWERS - reviewers.length

        Developer.
          queue
          .where.not(id: reviewers + [requester]).
          where(slack_workspace: @slack_workspace).
          limit(to_take)
      end

      def pick_reviewers_by_name(names)
        return [] if names.empty?

        names.map { |name| Developer.find_by(slack_workspace: @slack_workspace, name: name) }
      end
    end
  end
end
