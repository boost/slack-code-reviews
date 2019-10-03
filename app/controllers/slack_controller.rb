class SlackController < ApplicationController
  before_action :verify_slack_identity

  def create
    return error if @error
    response = Slack::ArgumentParser.new(params[:text]).call
    render json: {text: response}
  end

  private

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

  def error
    render json: {
      response_type: 'ephemeral',
      text: @error
    }
  end
end
