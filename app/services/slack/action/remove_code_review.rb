# frozen_string_literal: true

module Slack
  module Action
    # Removes a code by URL, it will remove only the first one found
    class RemoveCodeReview < Slack::AbstractAction
      def initialize(slack_workspace, url)
        super(slack_workspace)
        code_review = @slack_workspace.code_reviews.find_by(url: url)
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
