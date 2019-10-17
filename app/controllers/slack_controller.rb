# frozen_string_literal: true

class SlackController < ApplicationController
  include Slackable

  before_action :verify_slack_identity

  def create
    return render_error if @error

    args = Slack::ArgumentParser.new(params[:text]).call
    args.slack_workspace = SlackWorkspace.find_or_create_by(slack_workspace_id: params[:slack_workspace_id])
    args.requester = Developer.find_by(slack_workspace: args.slack_workspace, name: "@#{params[:user_name]}")
    action = Slack::ActionFactory.new(args).call

    render json: action.call
  end

  def error
    render json: { text: 'Wrong path' }
  end
end
