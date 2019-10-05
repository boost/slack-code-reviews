# frozen_string_literal: true

namespace :codereview do
  desc 'Use this command as you would use the /cr command in slack (-h for more info)'
  task :run, [:text] => :environment do |t, args|
    params = Slack::Utils.generate_params(args.text)
    timestamp = Time.now.to_i

    response = RestClient.post(
      'localhost:3000/slack', params,
      'X-Slack-Request-Timestamp': timestamp,
      'X-Slack-Signature': Slack::Utils.signature(SLACK_SIGNING_SECRET, timestamp, params)
    )
    json = JSON.parse(response.body)
    puts(json['response_type'] == 'in_channel' ? 'Visibible to everybody' : 'Visibile to you only')
    puts(json['text'])
  end
end
