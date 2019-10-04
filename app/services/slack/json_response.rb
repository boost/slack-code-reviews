# frozen_string_literal: true

module Slack
  class JsonResponse
    def initialize(text, visibility)
      @text = text
      @visibility = visibility
    end

    def call
      {
        response_type: @visibility,
        text: @text
      }
    end
  end
end
