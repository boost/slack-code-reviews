# frozen_string_literal: true

# A Developer has many code reviews through the developers_code_reviews table
# because it's a many-to-many relationship.
# It is attached to a slack_workspace because the username is not unique
# across worksapces in Slack
class Developer < ApplicationRecord
  belongs_to :slack_workspace
  belongs_to :project, optional: true

  has_many :developers_code_reviews
  has_many :code_reviews, through: :developers_code_reviews

  validates :name, presence: true

  class << self
    def queue
      developer_queue = DevelopersCodeReview.developer_queue.to_sql

      joins("LEFT OUTER JOIN (#{developer_queue}) dcr ON id = dcr.developer_id")
        .order(max_updated_at: :asc)
    end
  end
end
