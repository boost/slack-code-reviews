# frozen_string_literal: true

class SlackController < ApplicationController
  include Slackable

  before_action :verify_slack_identity

  def create
    return render_error if @error

    options = Slack::ArgumentParser.new(params[:text].split).call
    options.slack_workspace = SlackWorkspace.find_or_create_by(slack_workspace_id: params[:slack_workspace_id])
    options.requester = Developer.find_by(slack_workspace: options.slack_workspace, name: "@#{params[:user_name]}")

    render json: Slack::ActionFactory.build(options).call
  end

  def error
    render json: { text: 'Wrong path' }
  end
end
