# frozen_string_literal: true

# A Slack command is always sending a POST request with the user input as
# params[:text]
# See here: https://api.slack.com/interactivity/slash-commands
class SlackController < ApplicationController
  include Slackable
  rescue_from Unauthorized, with: :unauthorized
  before_action :verify_slack_identity

  before_action :create_slack_workspace
  before_action :create_requester
  after_action :send_message, only: %i[slash_command]

  def slash_command
    options = Slack::ArgumentParser.new(params[:text].split).call
    options.slack_workspace = @slack_workspace
    options.requester = @developer

    @action = Slack::ActionFactory.build(options)

    render json: ''
  end

  def interaction

  end

  def error
    render json: { text: 'Wrong path' }
  end

private

  def send_message
    payload = render_to_string(@action.view)

    RestClient.post(
      params[:response_url],
      payload,
      content_type: :json, accept: :json, charset: 'utf-8'
    )
  rescue RestClient::InternalServerError
    Rails.logger.info("Error in payload #{payload}")
  end

  def create_slack_workspace
    @slack_workspace = SlackWorkspace.find_or_create_by(
      slack_workspace_id: params[:slack_workspace_id]
    )
  end

  def create_requester
    @developer = @slack_workspace.developers.find_or_create_by(
      slack_id: params[:user_id],
      name: params[:user_name]
    )
  end

  def unauthorized
    render json: {
      response_type: :ephemeral,
      text: e.message
    }
  end
end
