module Slack
  class ActionFactory
    def initialize(args)
      if args.help.present?
        @action = Slack::Action::Help.new(args)
      elsif args.add_developer.present?
        @action = Slack::Action::AddDeveloper.new(args)
      elsif args.delete_developer.present?
        @action = Slack::Action::DeleteDeveloper.new(args)
      elsif args.list_developers.present?
        @action = Slack::Action::ListDevelopers.new(args)
      elsif args.url.present?
        @action = Slack::Action::CreateCodeReview.new(args)
      else
        raise 'Wrong arguments'
      end

    end

    def call
      return @action
    end
  end
end
