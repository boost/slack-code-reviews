# frozen_string_literal: true

# handles the interactions coming from Slack
module SlackInteractable
  extend ActiveSupport::Concern

  def answer_interaction
    @action = Slack::InteractionFactory.new(params[:payload]).call
    @action.save_state
    view = render_to_string(@action.view)
    @action.answer_to_interaction(view)
  end
end
