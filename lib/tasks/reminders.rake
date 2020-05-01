namespace :reminders do
  desc 'Alert a developer that they are away'
  task away: :environment do
    Developer.away.each do |developer|
      Slack::Api::ChatPostMessage.new(
        channel: developer['slack_id'],
        text: "Your status on the Code Review app is currently set to away. You can set it to available like so `/cr -a set -o developer -d #{developer.tag} --available`.",
        username: 'Code Reviews',
        token: ENV['SLACK_BOT_USER_OAUTH_ACCESS_TOKEN'],
      ).call
    end
  end
end
