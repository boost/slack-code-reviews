module Slack
  module Action
    class AddDeveloper < Slack::AbstractAction
      def initialize(args)
        super(args)
        Developer.find_or_create_by(team: @team, name: args.add_developer)
        @text = "Developer <#{args.add_developer}> added"
      end
    end
  end
end
