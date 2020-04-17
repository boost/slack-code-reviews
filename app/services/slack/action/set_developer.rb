# frozen_string_literal: true

module Slack
  module Action
    # Displays to the user if the developer exists or not
    class SetDeveloper < Slack::AbstractAction
      def initialize(slack_workspace, developer_tag, attributes)
        super(slack_workspace)

        developer = @slack_workspace.developers.find_by_tag(developer_tag)

        away_status = attributes.shift

        available_conversations = Slack::Api::UsersConversations.new({types: 'im'}).call

        # Work out the correct user to send the message to..
        available_conversations['channels'].each do |channel|
          user = Slack::Api::UsersInfo.new(channel['user']).call
        end

        if developer.nil?
          @text = "Developer \"#{developer_tag}\" not found."

        elsif !away_status.in? %w[away back]
          @text = 'Please choose either "away" or "back".'

        elsif away_status.to_s == developer.away.to_s
          @text = "Developer \"#{developer_tag}\" is already #{away_status}"

        else
          developer.update(away: away_status == 'away')
          @text = "Developer \"#{developer_tag}\" is now #{away_status}"
        end
      end
    end
  end
end
