# frozen_string_literal: true

module Slack
  class AbstractAction
    def initialize(args)
      @visibility = :ephemeral
      @team = args.team
    end

    def call
      Slack::JsonResponse.new(@text, @visibility).call
    end
  end
end
