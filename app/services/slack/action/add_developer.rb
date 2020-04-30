# frozen_string_literal: true

module Slack
  module Action
    # Adds a developer to a slack workspace, returns a specific message if the
    # developer was already present
    class AddDeveloper < Slack::AbstractAction
      def initialize(slack_workspace, developer)
        super(slack_workspace)

        if developer.blank?
          developer = create_developer(developer_tag)
          @text = "Developer #{developer.tag} added."
        else
          @text = "#{developer.tag} is already part of the developers."
        end
      end

    private

      def create_developer(developer_tag)
        Developer.create(
          slack_workspace: @slack_workspace,
          tag: developer_tag
        )
      end
    end
  end
end
