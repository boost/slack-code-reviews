# frozen_string_literal: true

module Slack
  module Action
    class GetCodeReview < Slack::AbstractAction
      def initialize(slack_workspace, url)
        super(slack_workspace)

        code_review = CodeReview.find_by(slack_workspace: @slack_workspace, url: url)
        if code_review
          @text = "#{code_review.url} code review exists."
        else
          @text = "Code review #{url} not found."
        end
      end
    end
  end
end
