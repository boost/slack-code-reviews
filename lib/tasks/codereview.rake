# frozen_string_literal: true

namespace :codereview do
  desc 'You can use this command with bin/codectl'

  task :run, [:text] => :environment do |_t, args|
    params = Slack::Utils.generate_params(args.text)
    timestamp = Time.now.to_i

    response = RestClient.post(
      'localhost:3000/slack-api/slash-command', params,
      'X-Slack-Request-Timestamp': timestamp,
      'X-Slack-Signature': Slack::Utils.signature(
        SLACK_SIGNING_SECRET, timestamp, params
      )
    )
    json = JSON.parse(response.body)

    if json['response_type'] == 'in_channel'
      puts('Visibible to everybody')
    else
      puts('Visibile to you only')
    end
    puts(json['text'])
  end
end
