# frozen_string_literal: true

class Developer < ApplicationRecord
  belongs_to :slack_workspace
  belongs_to :project, optional: true

  has_many :developers_code_reviews
  has_many :code_reviews, through: :developers_code_reviews

  scope :in_slack_workspace,      ->(workspace) { where(slack_workspace: workspace) }
  scope :havnt_recieved_a_review, -> { where(code_reviews: []) }

  class << self
    def pick_reviewer(workspace, name: nil, exclude: [])
      return pick_specific_reviewer(workspace, name) if name

      pick_next_reviewer(workspace, exclude: exclude)
    end

    # Pick a specific develoepr for code review
    def pick_specific_reviewer(workspace, name)
      reviewer = find_by(slack_workspace: workspace, name: name)
      return reviewer if reviewer.present?

      raise ActiveRecord::RecordNotFound, "<#{name}> not found"
    end

    # Pick the next developer up for code review
    def pick_next_reviewer(workspace, exclude: [])
      workspace_developers = in_slack_workspace(workspace)

      available_developers = workspace_developers.to_a - exclude

      reviewer = available_developers.min_by do |developer|
        developer.code_reviews.last&.created_at || DateTime.new(0) # along time ago
      end

      return reviewer if reviewer.present?

      raise ActiveRecord::RecordNotFound, 'Could not find an available reviewer'
    end
  end
end
