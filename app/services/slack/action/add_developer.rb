# frozen_string_literal: true

module Slack
  module Action
    class AddDeveloper < Slack::AbstractAction
      def initialize(slack_workspace, developer_name)
        super(slack_workspace)
        developer = Developer.find_by(name: developer_name)

        if developer.blank?
          developer = Developer.create(slack_workspace: @slack_workspace, name: developer_name)
          @text = "Developer <#{developer.name}> added."
        else
          @text = "Developer <#{developer.name}> is already part of the developers."
        end
      end
    end
  end
end
