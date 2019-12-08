# frozen_string_literal: true

# A code review has many developers through developers_code_reviews table
# because it's a many-to-many relationship
class CodeReview < ApplicationRecord
  belongs_to :slack_workspace

  has_many :developers_code_reviews
  has_many :developers, through: :developers_code_reviews
end
