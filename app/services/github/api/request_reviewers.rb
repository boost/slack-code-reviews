# frozen_string_literal: true

module Github
  module Api
    class RequestReviewers < Github::Api::Request
      def self.post(code_review_url, developers)
        github_names = developers.map(&:github_name).keep_if(&:present?)
        return if github_names.empty?

        path = [
          '/repos',
          code_review_url.organisation,
          code_review_url.project,
          'pulls',
          code_review_url.request_id,
          'requested_reviewers'
        ].join('/')

        super(
          path: path,
          payload: { reviewers: github_names }
        )
      end
    end
  end
end
