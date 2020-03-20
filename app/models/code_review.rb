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

  after_commit :request_reviewers, unless: :draft?

  def slack_request
    text = note.nil? ? '' : "[#{note}] "
    text += reviewers.map(&:tag).join(', ')
    text += ": #{requester.tag} is asking to review: "
    return text + urls.first.slack_url if urls.count == 1

    text + "\n- " + urls.map(&:slack_url).join("\n- ")
  end

private

  def request_reviewers
    urls.select(&:github_format?).each do |url|
      Github::Api::RequestReviewers.post(
        url,
        developers
      )
    end
  end
end
