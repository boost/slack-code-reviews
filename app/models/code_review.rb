# frozen_string_literal: true

class CodeReview < ApplicationRecord
  belongs_to :slack_workspace

  has_many :developers_code_reviews
  has_many :developers, through: :developers_code_reviews
end
