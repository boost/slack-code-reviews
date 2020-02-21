# frozen_string_literal: true

# A project is defined to assign developers in it
# This is done to enable a policy of having at least 1 code reviewer from the
# project picked up
class Project < ApplicationRecord
  before_save :update_type

  belongs_to :slack_workspace

  has_many :developers

  REQUIRED_NUMBER_OF_REVIEWERS = 2

  def update_type
    self.type = name.capitalize
  end

  def pick_external_reviewers(reviewers, requester)
    to_take = REQUIRED_NUMBER_OF_REVIEWERS - reviewers.length

    Developer
      .queue
      .where.not(id: reviewers + [requester])
      .where(slack_workspace: @slack_workspace)
      .limit(to_take)
  end
end
