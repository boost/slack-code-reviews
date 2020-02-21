# frozen_string_literal: true

# Natlib projects use dnz developers as external reviewers
class Natlib < Project
  def pick_external_reviewers(reviewers, requester)
    to_take = REQUIRED_NUMBER_OF_REVIEWERS - reviewers.length

    Developer
      .queue
      .where.not(id: reviewers + [requester])
      .where(slack_workspace: @slack_workspace, project: Project.dnz)
      .limit(to_take)
  end
end
