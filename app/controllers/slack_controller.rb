# frozen_string_literal: true

# A Slack command is always sending a POST request with the user input as
# params[:text]
# See here: https://api.slack.com/interactivity/slash-commands
class SlackController < ApplicationController
  include Slackable
  include SlackCommandable
  include SlackInteractable

  rescue_from Unauthorized, with: :unauthorized
  before_action :verify_slack_identity

  before_action :create_slack_workspace
  before_action :create_requester

  after_action :answer_command, only: %i[slash_command]
  after_action :answer_interaction, only: %i[interaction]

  def slash_command
    render json: ''
  end

  def interaction
    render json: ''
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

  def create_requester
    @developer = @slack_workspace.developers.find_or_create_by(
      slack_id: params[:user_id],
      name: params[:user_name]
    )
  end

  def unauthorized(error)
    render json: {
      response_type: :ephemeral,
      text: error.message
    }
  end
end
