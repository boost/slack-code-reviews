# frozen_string_literal: true

module Slack
  class AbstractAction
    def initialize(args)
      @visibility = :ephemeral
      @slack_workspace = args.slack_workspace
    end

    def call
      Slack::JsonResponse.new(@text, @visibility).call
    end
  end
end
