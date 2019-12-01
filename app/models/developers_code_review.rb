# frozen_string_literal: true

class DevelopersCodeReview < ApplicationRecord
  belongs_to :code_review
  belongs_to :developer

  class << self
    def developer_queue
      select('developer_id, max(updated_at) max_updated_at').
      group(:developer_id)
    end
  end
end
