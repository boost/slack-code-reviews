# frozen_string_literal: true

module Slack
  class AbstractAction
    def initialize(slack_workspace)
      @visibility = :ephemeral
      @slack_workspace = slack_workspace
    end

    def call
      Slack::JsonResponse.new(@text, @visibility).call
    end
  end
end
