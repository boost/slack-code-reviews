# frozen_string_literal: true

module Slack
  module Action
    class CreateCodeReview < Slack::AbstractAction
      def initialize(args)
        super(args)
        @visibility = :in_channel

        puts "URL: #{args.list[0]}"
        puts "REVIEWER1: #{args.list[1]}"
        puts "REVIEWER2: #{args.list[2]}"
        url = args.list[0]
        reviewer1 = find_or_pick_a_reviewer(args.list[1])
        reviewer2 = find_or_pick_a_reviewer(args.list[2], reviewer1)

        @text = "New CR: #{url} <#{reviewer1.name}> <#{reviewer2.name}>"
      rescue NotEnoughDeveloperError => e
        @visibility = :ephemeral
        @text = e.message
      end

      private

        def find_or_pick_a_reviewer(name, do_not_pick = nil)
          reviewer = Developer.find_by(team: @team, name: name)
          return reviewer if reviewer

          request = Developer.where(team: @team)
          request = request.where.not(id: do_not_pick.id) unless do_not_pick.nil?

          if request.count < 2
            raise NotEnoughDeveloperError,
                  'You must have at least 2 developers to create a code review.'
          end

          # to improve to use a queue instead of a random system
          request.offset(rand(request.count)).first
        end
    end
  end
end
