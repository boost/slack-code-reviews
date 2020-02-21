# frozen_string_literal: true

# A code review has many developers through developers_code_reviews table
# because it's a many-to-many relationship
class CodeReview < ApplicationRecord
  belongs_to :slack_workspace
  belongs_to :requester, class_name: 'Developer'

  has_many :urls, inverse_of: :code_review
  has_many :developers_code_reviews, inverse_of: :code_review
  has_many :developers, through: :developers_code_reviews

  alias_attribute :reviewers, :developers

  scope :drafts, -> { where(draft: false) }
end
