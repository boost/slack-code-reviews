module Slack
  class JsonResponse
    def initialize(text, visibility)
      @text = text
      @visibility = visibility
    end

    def call
      return {
        response_type: @visibility,
        text: @text
      }
    end
  end
end
