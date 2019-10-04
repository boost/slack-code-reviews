module Slack
  class AbstractAction
    def initialize(args)
      @visibility = :ephemeral
      @team = args.team
    end

    def call
      return Slack::JsonResponse.new(@text, @visibility).call
    end
  end
end
