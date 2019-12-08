# frozen_string_literal: true

module Slack
  module Action
    # Displays a list of code reviews containing url and developers
    class ListCodeReviews < Slack::AbstractAction
      def initialize(slack_workspace)
        super(slack_workspace)

        code_reviews = workspace_code_reviews.map do |code_review|
          "    - [#{code_review.created_at}] #{code_review.url} -> " +
            developers_name_list(code_review)
        end

        @text = (['**Code reviews:**'] + code_reviews).join("\n")
        @text = 'No code_reviews added yet.' if code_reviews.empty?
      end

    private

      def developers_name_list(code_review)
        code_review.developers.map do |developer|
          "<#{developer.name}>"
        end.join(', ')
      end

      def workspace_code_reviews
        @slack_workspace.code_reviews.order(created_at: :desc)
      end
    end
  end
end
