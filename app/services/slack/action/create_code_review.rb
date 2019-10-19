# frozen_string_literal: true

module Slack
  module Action
    class CreateCodeReview < Slack::AbstractAction
      REQUIRED_NUMBER_OF_REVIEWERS = 2

      def initialize(slack_workspace, url, requester, given_reviewers_names)
        super(slack_workspace)

        @visibility = :in_channel
        @requester = requester
        @project = requester&.project
        @reviewers = []

        pick_reviewers(given_reviewers_names) # assigns @reviewers

        CodeReview.create(slack_workspace: slack_workspace, url: url, developers: @reviewers)

        @text = "New CR: #{url} <#{reviewers.first.name}> <#{reviewers.second.name}>"
      rescue ActiveRecord::RecordNotFound => e
        @visibility = :ephemeral
        @text = e.message
      end

    private

      def pick_reviewers(given_reviewers_names = [])
        # pick out the specified users from the reviwer (if any provided)
        pick_reviewers_by_name(names)
        return if @reviewers.length == REQUIRED_NUMBER_OF_REVIEWERS

        # if we need a reviewer from the project ..
        pick_remaining_reviewers_from_queue unless reviewer_on_project?(@reviewers)

        # pick the remaining required number of developers from the queue
        pick_project_reviewer
      end

      def exclude
        @reviewers + [@requester]
      end

      def pick_reviewers_by_name(workspace, names, exclude: [])
        return if names.empty?

        @reviewers.push names.map do |name|
          Developer.pick_reviewer(
            workspace,
            name: name,
            exclude: exclude
          )
        end
      end

      def reviewer_on_project?
        return true if @project.nil?

        @reviewers.any? do |reviewer|
          reviewer.project == @project
        end
      end

      def pick_project_reviewer
        # .. if there are no developers we can pick, continue
        return if no_project_developers_available?

        # .. else, pick one from the project
        @reviewers.push Developer.pick_reviewer(
          @slack_workspace,
          exclude: exclude,
          project: @project
        )
      end

      def no_project_developers_available?
        (@project.developers.all - exclude).empty?
      end

      def remaining_reviewers_needed
        REQUIRED_NUMBER_OF_REVIEWERS - @reviewers.length
      end

      def pick_remaining_reviewers_from_queue
        remaining_reviewers_needed.times do
          @reviewers.push Developer.pick_reviewer(workspace, exclude: exclude)
        end
      end
    end
  end
end
