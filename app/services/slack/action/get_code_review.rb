# frozen_string_literal: true

module Slack
  module Action
    # displays to the command user if the code review with this url exists
    class GetCodeReview < Slack::AbstractAction
      def initialize(slack_workspace, url)
        super(slack_workspace)

        code_review = CodeReview.includes(:urls).find_by(
          slack_workspace: @slack_workspace,
          urls: { url: url }
        ).first
        @text = assign_text(code_review)
      end

    private

      def assign_text(code_review)
        if code_review
          "#{code_review.url} code review exists."
        else
          "Code review #{url} not found."
        end
      end
    end
  end
end
