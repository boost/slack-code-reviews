class SlackController < ApplicationController
  before_action :verify_slack_identity
  before_action :team

  def create
    return render_error if @error

    args = Slack::ArgumentParser.new(params[:text]).call
    @visibility = :ephemeral
    if args.help.present?
      @text = args.help
    elsif args.add_developer.present?
      Developer.find_or_create_by(team: @team, name: args.add_developer)
      @text = "Developer <#{args.add_developer}> added"
    elsif args.delete_developer.present?
      Developer.find_by(team: @team, name: args.delete_developer).destroy
      @text = "Developer <#{args.delete_developer}> deleted"
    elsif args.list_developers.present?
      @text = (["Listing developers"] + Developer.where(team: @team).map { |d| "    - #{d.name}" }).join("\n")
    elsif args.url.present?
      @visibility = :in_channel
      @text = "New CR: #{args.url} #{args.developer}"
    end
    render json: { response_type: @visibility, text: @text }
  end

  def error
    render json: { text: 'Wrong path' }
  end

  private

  def team
    return @team if @team

    @team = Team.find_or_create_by(team_id: params[:team_id])
  end

  def verify_slack_identity
    timestamp = request.headers['X-Slack-Request-Timestamp']
    sig_basestring = "v0:#{timestamp}:#{request.raw_post}"
    slack_signature = request.headers['X-Slack-Signature']
    signature = "v0=" + OpenSSL::HMAC.hexdigest('sha256', SLACK_SIGNING_SECRET, sig_basestring)

    if (Time.now - Time.at(timestamp.to_i)).abs / 1.second > 5.minute
      @error = 'Sorry, the time looks wrong. Please try again'
      return
    end

    if slack_signature != signature
      @error = 'Sorry, the signature is wrong'
    end
  end

  def render_error
    render json: {
      response_type: 'ephemeral',
      text: @error
    }
  end
end
