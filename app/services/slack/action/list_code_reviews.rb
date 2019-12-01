# frozen_string_literal: true

module Slack
  module Action
    class ListCodeReviews < Slack::AbstractAction
      def initialize(slack_workspace)
        super(slack_workspace)

        code_reviews = CodeReview.where(slack_workspace: @slack_workspace).order(created_at: :desc).map do |code_review|
          "    - [#{code_review.created_at}] #{code_review.url} -> " + code_review.developers.map do |developer|
            "<#{developer.name}>"
          end.join(', ')
        end

        @text = (['**Code reviews:**'] + code_reviews).join("\n")
        @text = 'No code_reviews added yet.' if code_reviews.empty?
      end
    end
  end
end
