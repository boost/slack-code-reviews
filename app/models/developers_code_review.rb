# frozen_string_literal: true

class DevelopersCodeReview < ApplicationRecord
  belongs_to :code_review
  belongs_to :developer
end
