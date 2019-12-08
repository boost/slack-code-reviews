# frozen_string_literal: true

module Slack
  module Action
    # Adds a developer to a slack workspace, returns a specific message if the
    # developer was already present
    class AddDeveloper < Slack::AbstractAction
      def initialize(slack_workspace, developer_name)
        super(slack_workspace)
        developer = @slack_workspace.developers.find_by(name: developer_name)

        if developer.blank?
          developer = create_developer(developer_name)
          @text = "Developer <#{developer.name}> added."
        else
          @text = "<#{developer.name}> is already part of the developers."
        end
      end

    private

      def create_developer(developer_name)
        Developer.create(
          slack_workspace: @slack_workspace,
          name: developer_name
        )
      end
    end
  end
end
