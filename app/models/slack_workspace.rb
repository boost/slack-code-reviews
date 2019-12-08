# frozen_string_literal: true

# A slack workspace is what you on the top-left corner in Slack. It's Boost for
# us
class SlackWorkspace < ApplicationRecord
  has_many :developers
  has_many :projects
  has_many :code_reviews
end
