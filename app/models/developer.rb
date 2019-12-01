# frozen_string_literal: true

class Developer < ApplicationRecord
  belongs_to :slack_workspace
  belongs_to :project, optional: true

  has_many :developers_code_reviews
  has_many :code_reviews, through: :developers_code_reviews

  scope :in_slack_workspace,      ->(workspace) { where(slack_workspace: workspace) }
  scope :havnt_recieved_a_review, -> { where(code_reviews: []) }

  class << self
    def queue
      developer_queue = DevelopersCodeReview.developer_queue.to_sql

      joins("LEFT OUTER JOIN (#{developer_queue}) dcr ON id = dcr.developer_id").
      order(max_updated_at: :asc)
    end
  end
end
