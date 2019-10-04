module Slack
  module Action
    class ListDevelopers < Slack::AbstractAction
      def initialize(args)
        super(args)
        developers = Developer.where(team: @team).map { |d| "    - #{d.name}" }
        @text = (["Listing developers"] + developers).join("\n")
      end
    end
  end
end
