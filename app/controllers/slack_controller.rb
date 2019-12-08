# frozen_string_literal: true

# A Slack command is always sending a POST request with the user input as
# params[:text]
# See here: https://api.slack.com/interactivity/slash-commands
class SlackController < ApplicationController
  include Slackable

  before_action :verify_slack_identity
  before_action :create_slack_workspace
  before_action :find_developer

  rescue_from Unauthorized, with: :unauthorized

  def create
    options = Slack::ArgumentParser.new(params[:text].split).call
    options.slack_workspace = @slack_workspace
    options.requester = @developer

    render json: Slack::ActionFactory.build(options).call
  end

  def error
    render json: { text: 'Wrong path' }
  end

private

  def create_slack_workspace
    @slack_workspace = SlackWorkspace.find_or_create_by(
      slack_workspace_id: params[:slack_workspace_id]
    )
  end

  def find_developer
    @developer = @slack_workspace.developers.find_by(
      name: "@#{params[:user_name]}"
    )
  end

  def unauthorized
    render json: {
      response_type: :ephemeral,
      text: e.message
    }
  end
end
