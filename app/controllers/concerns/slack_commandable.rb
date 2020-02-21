# frozen_string_literal: true

# handles the commands sent by Slack
module SlackCommandable
  extend ActiveSupport::Concern

  def answer_command
    options = Slack::ArgumentParser.new(params[:text].split).call
    options.slack_workspace = @slack_workspace
    options.requester = @developer

    @action = Slack::ActionFactory.build(options)
    Rails.logger.debug("Action: #{@action.class}")

    view_string = render_to_string(@action.view)
    @action.respond_to_command(view_string, params)
  rescue RestClient::InternalServerError => e
    Rails.logger.error(e)
    Rails.logger.info("Error in payload #{view_string}")
  end
end
