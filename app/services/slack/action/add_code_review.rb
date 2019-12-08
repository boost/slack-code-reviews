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
        CodeReview.create(
          slack_workspace: @slack_workspace,
          url: url,
          developers: reviewers
        )

        @visibility = :in_channel
        @text = "New CR #{url} " + reviewers.map do |reviewer|
          "<#{reviewer.name}>"
        end.join(' ')
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

      def pick_reviewers_by_name(names)
        return [] if names.empty?

        names.map do |name|
          @slack_workspace.developers.find_by(name: name)
        end
      end
    end
  end
end
