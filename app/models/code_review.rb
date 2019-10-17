# frozen_string_literal: true

class CodeReview < ApplicationRecord
  belongs_to :slack_workspace

  has_many :reviewers
  has_many :developers, through: :reviewers
end
