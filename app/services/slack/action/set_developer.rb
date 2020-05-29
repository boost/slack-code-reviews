# frozen_string_literal: true

module Slack
  module Action
    # Displays to the user if the developer exists or not
    class SetDeveloper < Slack::AbstractAction
      def initialize(slack_workspace, developer, attributes)
        super(slack_workspace)

        if developer.away == attributes[:away]
          @text = "Developer \"#{developer.tag}\" is already #{developer.status}"
        elsif attributes[:github_name]
          developer.update_attributes!(attributes)
          @text = "Developer \"#{developer.tag}\" "\
           "is now associated with #{developer.github_name}"
        else
          developer.update_attributes!(attributes)
          @text = "Developer \"#{developer.tag}\" is now #{developer.status}"

          Slack::Api::ChatPostMessage.new(
            channel: developer['slack_id'],
            text: "Your status on the Code Review app has been set to #{developer.status}."\
            ' You can change like so '\
            "`/cr -a set -o developer -d #{developer.tag} --available || --away`.",
            username: 'Code Reviews',
            token: ENV['SLACK_BOT_USER_OAUTH_ACCESS_TOKEN']
          ).call
        end
      end
    end
  end
end
