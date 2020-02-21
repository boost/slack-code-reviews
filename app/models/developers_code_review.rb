# frozen_string_literal: true

# Links the developer and the code review
class DevelopersCodeReview < ApplicationRecord
  belongs_to :code_review
  belongs_to :developer

  class << self
    def developer_queue
      code_reviews = CodeReview.where(draft: false).to_sql
      max_updated_at = 'MAX(developers_code_reviews.updated_at) max_updated_at'

      joins("RIGHT OUTER JOIN (#{code_reviews}) cr ON code_review_id = cr.id")
        .select("developer_id, #{max_updated_at}")
        .group(:developer_id)
    end
  end
end
