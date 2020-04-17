# frozen_string_literal: true

# handles the commands sent by Slack
module SlackCommandable
  extend ActiveSupport::Concern

  def answer_command
    command_params = Shellwords.split(params[:text].gsub(/[“”]/, '"'))
    options = Slack::ArgumentParser.new.parse(command_params)
    options.slack_workspace = @slack_workspace
    options.requester = @developer
    options.channel_id = params[:channel_id]

    @action = Slack::ActionFactory.build(options)
    Rails.logger.debug("Action: #{@action.class}")

    view_string = render_to_string(@action.view)
    @action.respond_to_command(view_string, params)
  rescue RestClient::InternalServerError => e
    Rails.logger.error(e)
    Rails.logger.info("Error in payload #{view_string}")
  end
end
