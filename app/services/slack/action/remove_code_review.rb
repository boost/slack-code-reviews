# frozen_string_literal: true

module Slack
  module Action
    class RemoveCodeReview < Slack::AbstractAction
      def initialize(slack_workspace, url)
        super(slack_workspace)
        code_review = CodeReview.find_by(slack_workspace: @slack_workspace, url: url)
        if code_review
          code_review.destroy
          @text = "Code review #{code_review.url} removed."
        else
          @text = "Code review \"#{url}\" not found."
        end
      end
    end
  end
end
