# frozen_string_literal: true

# A code review has many developers through developers_code_reviews table
# because it's a many-to-many relationship
class CodeReview < ApplicationRecord
  belongs_to :slack_workspace
  belongs_to :requester, class_name: 'Developer'

  has_many :developers_code_reviews
  has_many :developers, through: :developers_code_reviews

  alias_attribute :reviewers, :developers

  scope :drafts, -> { where(draft: false) }

  before_save :sanitize_url

  URL_REGEX = /^<(.*)\|.*>$/.freeze

  def sanitize_url
    self.url = url.scan(URL_REGEX).flatten.first if url.match(URL_REGEX)
  end
end
