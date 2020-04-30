# frozen_string_literal: true

module Slack
  module Interaction
    class BlockActions < Slack::AbstractInteraction
      attr_accessor :dev_queue

      def save_state
        @dcr.save
        @cr.reload
        @view = 'slack/action/add_code_review_modal.json'
      end

      def answer_to_interaction(view_string)
        # Rails.logger.debug("view_string: #{view_string}")
        # response = Slack::Api::ViewsUpdate.new(
        #   view_id: @view_id,
        #   view: view_string
        # ).call
        # Rails.logger.debug("ViewsUpdate response: #{response}")
      end

    private

      def extract_info
        super

        @cr = CodeReview.find_by(view_id: @view_id)

        previous_reviewer = Developer.find_by(
          tag: @payload['actions'][0]['initial_option']['value']
        )
        new_reviewer = Developer.find_by(
          tag: @payload['actions'][0]['selected_option']['value']
        )
        @dcr = @cr.developers_code_reviews.find do |dcr|
          dcr.developer.id == previous_reviewer.id
        end
        @dcr.developer = new_reviewer
        @dev_queue = Developer.queue.where.not(id: @cr.requester)
      end
    end
  end
end
