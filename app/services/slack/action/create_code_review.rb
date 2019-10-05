# frozen_string_literal: true

module Slack
  module Action
    class CreateCodeReview < Slack::AbstractAction
      def initialize(args)
        super(args)
        @visibility = :in_channel
        # to be able using the cli waiting for proper cli paramters
        args.list = args.list[0].split('|') if args.list[0].include?('|')

        dont_pick = args.requester ? [args.requester] : []
        reviewer1 = Developer.pick_for_review(args.team, args.list[1], dont_pick)
        reviewer2 = Developer.pick_for_review(args.team, args.list[2], dont_pick + [reviewer1])

        @text = "New CR: #{args.list[0]} <#{reviewer1.name}> <#{reviewer2.name}>"
      rescue ActiveRecord::RecordNotFound => e
        @visibility = :ephemeral
        @text = e.message
      end
    end
  end
end
