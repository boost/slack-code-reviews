# frozen_string_literal: true

class Reviewer < ApplicationRecord
  belongs_to :code_review
  belongs_to :developer
end
