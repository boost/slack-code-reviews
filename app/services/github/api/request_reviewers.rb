# frozen_string_literal: true

module Github
  module Api
    class RequestReviewers < Request
      def self.post(url, developers)
        github_names = developers.map(&:github_name).keep_if(&:present?)
        return if github_names.empty?

        path = [
          '/repos',
          url.organisation,
          url.project,
          'pulls',
          url.request_id,
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
