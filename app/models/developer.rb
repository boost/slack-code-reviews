# frozen_string_literal: true

# A Developer has many code reviews through the developers_code_reviews table
# because it's a many-to-many relationship.
# It is attached to a slack_workspace because the username is not unique
# across worksapces in Slack
class Developer < ApplicationRecord
  include SlackTaggable
  tag_character '@'

  # relationships
  belongs_to :slack_workspace
  belongs_to :project, optional: true
  has_many :developers_code_reviews
  has_many :code_reviews, through: :developers_code_reviews
  has_many :requests,
           class_name: 'CodeReview',
           foreign_key: 'requester_id',
           inverse_of: :requester

  # validations
  validates :name, presence: true
  validates :slack_id, presence: true

  # callbacks
  before_create :enrich_from_api

  def enrich_from_api
    response = Slack::Api::UsersInfo.new(slack_id).call
    self.avatar_url = response['user']['profile']['image_512']
  end

  def self.queue
    developer_queue = DevelopersCodeReview.developer_queue.to_sql

    joins("LEFT OUTER JOIN (#{developer_queue}) dcr ON id = dcr.developer_id")
      .where(away: false)
      .order(max_updated_at: :asc)
  end
end
