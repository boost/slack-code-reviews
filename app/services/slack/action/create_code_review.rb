module Slack
  module Action
    class CreateCodeReview < Slack::AbstractAction
      def initialize(args)
        super(args)
        @visibility = :in_channel
        @text = "New CR: #{args.url} #{args.developer}"
      end
    end
  end
end
