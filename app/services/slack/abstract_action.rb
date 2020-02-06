# frozen_string_literal: true

module Slack
  # This is the base class for Slack Actions, the behaviour of call is always
  # the same
  # And slack workspace is needed most of the time, the visibility is set to
  # :ephemeral which means Only visible to the sender
  class AbstractAction
    attr_accessor :visibility
    attr_accessor :text

    def initialize(slack_workspace)
      @visibility = :ephemeral
      @slack_workspace = slack_workspace
    end

    def view
      'slack/action/simple_message.json'
    end

    def call
      Slack::JsonResponse.new(@text, @visibility).call
    end

    def respond_to_command(payload, params)
      response = Slack::Api::ResponseUrl.new(
        params[:response_url], payload
      ).call
      handle_response(response)
    end

    def handle_response(response); end
  end
end
