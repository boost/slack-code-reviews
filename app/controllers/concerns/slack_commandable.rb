# frozen_string_literal: true

# handles the commands sent by Slack
module SlackCommandable
  extend ActiveSupport::Concern

  def answer_command
    options = Slack::ArgumentParser.new(params[:text].split).call
    options.slack_workspace = @slack_workspace
    options.requester = @developer

    @action = Slack::ActionFactory.build(options)

    payload = render_to_string(@action.view)
    @action.respond_to_command(payload, params)
  rescue RestClient::InternalServerError
    Rails.logger.info("Error in payload #{payload}")
  end
end
