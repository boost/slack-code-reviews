# frozen_string_literal: true

module Slack
  module Action
    class CreateCodeReview < Slack::AbstractAction
      def initialize(args)
        super(args)
        @visibility = :in_channel
        # to be able using the cli waiting for proper cli paramters
        args.list = args.list[0].split('|') if args.list[0].include?('|')

        reviewers = pick_reviewers(args.slack_workspace, args.list[1..2], args.requester.presence)

        CodeReview.create(slack_workspace: args.slack_workspace, developers: reviewers)

        @text = "New CR: #{args.list[0]} <#{reviewers.first.name}> <#{reviewers.second.name}>"
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
