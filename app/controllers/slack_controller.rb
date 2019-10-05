# frozen_string_literal: true

class SlackController < ApplicationController
  include Slackable

  before_action :verify_slack_identity

  def create
    return render_error if @error

    args = Slack::ArgumentParser.new(params[:text]).call
    args.team = Team.find_or_create_by(team_id: params[:team_id])
    args.requester = Developer.find_by(team: args.team, name: "@#{params[:user_name]}")
    action = Slack::ActionFactory.new(args).call

    render json: action.call
  end

  def error
    render json: { text: 'Wrong path' }
  end
end
