# frozen_string_literal: true

class SlackWorkspace < ApplicationRecord
  has_many :developers
  has_many :projects
end
