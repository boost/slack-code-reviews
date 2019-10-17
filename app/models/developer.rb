# frozen_string_literal: true

class Developer < ApplicationRecord
  belongs_to :slack_workspace

  scope :in_slack_workspace, ->(slack_workspace) { where(slack_workspace: slack_workspace) }

  def self.pick_for_review(slack_workspace, name = nil, do_not_pick = [])
    if name
      reviewer = find_by(slack_workspace: slack_workspace, name: name)
      raise ActiveRecord::RecordNotFound, "<#{name}> not found" unless reviewer
    else
      query = in_slack_workspace(slack_workspace)
      do_not_pick.each { |dev| query = query.where.not(id: dev.id) }
      reviewer = query.sample
      raise ActiveRecord::RecordNotFound, 'Could not find an available reviewer' unless reviewer
    end

    reviewer
  end
end
