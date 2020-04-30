# frozen_string_literal: true

module Slack
  module Action
    # Displays to the user if the developer exists or not
    class SetDeveloper < Slack::AbstractAction
      def initialize(slack_workspace, developer, attributes)
        super(slack_workspace)

        away_status = attributes.shift

        if developer.nil?
          @text = "Developer \"#{developer_tag}\" not found."

        elsif !away_status.in? %w[away back]
          @text = 'Please choose either "away" or "back".'

        elsif away_status.to_s == developer.away.to_s
          @text = "Developer \"#{developer_tag}\" is already #{away_status}"

        else
          developer.update(away: away_status == 'away')
          @text = "Developer \"#{developer_tag}\" is now #{away_status}"

          Slack::Api::ChatPostMessage.new(
            channel: developer['slack_id'],
            text: "Your status on the Code Review app has been set to #{away_status}.",
            username: 'Code Reviews',
            token: ENV['SLACK_BOT_USER_OAUTH_ACCESS_TOKEN'],
          ).call
        end
      end
    end
  end
end
