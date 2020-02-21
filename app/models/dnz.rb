# frozen_string_literal: true

# Dnz projects use natlib developers as external reviewers
class Dnz < Project
  def pick_external_reviewers(reviewers, requester)
    to_take = REQUIRED_NUMBER_OF_REVIEWERS - reviewers.length

    Developer
      .queue
      .where.not(id: reviewers + [requester])
      .where(slack_workspace: @slack_workspace, project: Project.natlib)
      .limit(to_take)
  end
end
