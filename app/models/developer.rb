# frozen_string_literal: true

class Developer < ApplicationRecord
  belongs_to :team

  scope :in_team, ->(team) { where(team: team) }

  def self.pick_for_review(team, name = nil, do_not_pick = [])
    if name
      reviewer = find_by(team: team, name: name)
      raise ActiveRecord::RecordNotFound, "<#{name}> not found" unless reviewer
    else
      query = in_team(team)
      do_not_pick.each { |dev| query = query.where.not(id: dev.id) }
      reviewer = query.sample
      raise ActiveRecord::RecordNotFound, 'Could not find an available reviewer' unless reviewer
    end

    reviewer
  end
end
