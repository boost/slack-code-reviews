# frozen_string_literal: true

module Slack
  module Action
    class CreateCodeReview < Slack::AbstractAction
      def initialize(slack_workspace, url, requester, reviewers)
        super(slack_workspace)
        @visibility = :in_channel

        reviewers = pick_reviewers(slack_workspace, reviewers, requester)

        CodeReview.create(slack_workspace: slack_workspace, url: url, developers: reviewers)

        @text = "New CR: #{url} <#{reviewers.first.name}> <#{reviewers.second.name}>"
      rescue ActiveRecord::RecordNotFound => e
        @visibility = :ephemeral
        @text = e.message
      end

    private

      def pick_reviewers(workspace, names = [], requester = nil)
        reviewer1 = Developer.pick_reviewer(
          workspace,
          name: names.first.presence,
          exclude: [requester]
        )

        reviewer2 = Developer.pick_reviewer(
          workspace,
          name: names.second.presence,
          exclude: [requester, reviewer1]
        )

        [reviewer1, reviewer2]
      end
    end
  end
end
