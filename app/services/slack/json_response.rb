# frozen_string_literal: true

module Slack
  # This is used by the abstract action to generate a simple response for Slack.
  # It's a simple answer with a text and a visibility
  # See here: https://api.slack.com/interactivity/slash-commands
  class JsonResponse
    def initialize(text, visibility)
      @text = text
      @visibility = visibility
    end

    def call
      return @text.to_json if @text.class == Hash

      {
        response_type: @visibility,
        text: @text
      }
    end
  end
end
