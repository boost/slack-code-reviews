# frozen_string_literal: true

module Slack
  class ActionFactory
    def initialize(options)
      if options.help.present?
        @action = Slack::Action::Help.new(options)
      elsif options.crud == 'add' && options.resource == 'developer'
        @action = Slack::Action::AddDeveloper.new(options)
      elsif options.crud == 'remove' && options.resource == 'developer'
        @action = Slack::Action::DeleteDeveloper.new(options)
      elsif options.crud == 'list' && options.resource == 'developer'
        @action = Slack::Action::ListDevelopers.new(options)
      elsif options.crud == 'create' && options.resource == 'code-review'
        @action = Slack::Action::CreateCodeReview.new(options)
      else
        raise 'Wrong arguments'
      end
    end

    def call
      @action
    end
  end
end
