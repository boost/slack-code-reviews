# frozen_string_literal: true

module Slack
  # This is a temporary class for parsing user arguments passed in the slash
  # command
  # A proper library should be used in the future to parse the arguments.
  # It will enable some features like defaults
  class ArgumentParser
    VERSION = '1.0.0'

    class RestOptions
      attr_accessor :action, :object, :urls, :reviewers, :developer, :project
      attr_accessor :modal, :message, :slack_workspace, :requester, :channel_id
      attr_accessor :note

      ACTIONS = %w[add get list delete].freeze
      ACTION_ALIASES = {
        'a': 'add',
        'g': 'get',
        'l': 'list',
        'd': 'delete',
        'see': 'get',
        'index': 'list',
        'remove': 'delete'
      }.freeze

      OBJECTS = %w[code-review developer project project-developer].freeze
      OBJECT_ALIASES = {
        'd': 'developer',
        'p': 'project',
        'c': 'code-review',
        'cr': 'code-review',
        'pd': 'project-developer',
        'dp': 'project-developer',
        'developers': 'developer',
        'projects': 'project',
        'code-reviews': 'code-review',
        'projects-developers': 'project-developer',
        'project-developers': 'project-developer',
        'projects-developer': 'project-developer',
        'developers-projects': 'project-developer',
        'developer-projects': 'project-developer',
        'developers-project': 'project-developer'
      }.freeze

      def initialize
        self.message = nil
        self.action = 'add'
        self.object = 'code-review'
        self.urls = []
        self.reviewers = []
        self.developer = nil
        self.project = nil
        self.modal = false
        self.note = nil
      end

      def define_options(parser)
        parser.separator '```'
        parser.separator 'Usage: /cr [-a <action>] [-o <object>] [options]'

        parser.separator ''
        parser.separator 'ACTIONS:'
        on_action(parser)
        parser.separator "    Possible actions: #{ACTIONS.join(', ')}"

        parser.separator ''
        parser.separator 'OBJECTS:'
        on_object(parser)
        parser.separator "    Possible objects: #{OBJECTS.join(', ')}"

        parser.separator ''
        parser.separator 'OPTIONS:'
        on_url(parser)
        on_note(parser)
        on_reviewer(parser)
        on_developer(parser)
        on_project(parser)
        on_modal(parser)

        parser.separator ''
        parser.separator 'COMMON OPTIONS:'

        # No argument, shows at tail.  This will print an options summary.
        # Try it and see!
        parser.on('-h', '--help', 'Show this message') do
          self.message = parser.help
        end

        # Another typical switch to print the version.
        parser.on('-v', '--version', 'Show version') do
          self.message = VERSION
        end

        # rubocop:disable Layout/LineLength
        parser.separator ''
        parser.separator 'EXAMPLES:'
        parser.separator '    Create a code review:'
        parser.separator '        Long:          /cr --action add --object code-review --url https://github.com/boost/slack-code-reviews/pull/1'
        parser.separator '        Short:         /cr -a add -o code-review --url https://github.com/boost/slack-code-reviews/pull/1'
        parser.separator '        Shorter:       /cr -u https://github.com/boost/slack-code-reviews/pull/1'
        parser.separator '        Multiple URLs: /cr -u https://github.com/boost/slack-code-reviews/pull/1 -u https://github.com/boost/slack-code-reviews/pull/2'
        parser.separator '        With a note:   /cr -u https://github.com/boost/slack-code-reviews/pull/1 -n "That\'s my note"'
        parser.separator '        Reviewer:      /cr -u https://github.com/boost/slack-code-reviews/pull/1 -r @dave'
        parser.separator '        Reviewers:     /cr -u https://github.com/boost/slack-code-reviews/pull/1 -r @dave -r @richard'
        parser.separator ''
        parser.separator '    Manage developers:'
        parser.separator '        Add:    /cr -a add    -o developer -d @dave'
        parser.separator '        List:   /cr -a list   -o developer'
        parser.separator '        Get:    /cr -a get    -o developer -d @dave'
        parser.separator '        Remove: /cr -a delete -o developer -d @dave'
        parser.separator ''
        parser.separator '    Manage projects:'
        parser.separator '        Add:    /cr -a add    -o project -p natlib'
        parser.separator '        List:   /cr -a list   -o project'
        parser.separator '        Get:    /cr -a get    -o project -p natlib'
        parser.separator '        Remove: /cr -a delete -o project -p natlib'
        parser.separator ''
        parser.separator '    Manage the project-developer relationship:'
        parser.separator '        Add:    /cr -a add    -o project-developer -p dnz -d @dave'
        parser.separator '        List:   /cr -a list   -o project-developer'
        parser.separator '        Get:    /cr -a get    -o project-developer -p dnz -d @dave'
        parser.separator '        Remove: /cr -a delete -o project-developer -p dnz -d @dave'
        # rubocop:enable Layout/LineLength

        parser.separator '```'
      end

      def on_action(parser)
        # Specifies an optional option argument
        parser.on(
          '-a', '--action ACTION', ACTIONS, ACTION_ALIASES,
          'Action you would like to be executed, defaults to add'
        ) do |action|
          self.action << action
        end
      end

      def on_object(parser)
        # Specifies an optional option argument
        parser.on(
          '-o', '--object OBJECT', OBJECTS, OBJECT_ALIASES,
          'The object you want to act on, defaults to code-review'
        ) do |object|
          self.object << object
        end
      end

      def on_url(parser)
        # Specifies an optional option argument
        parser.on(
          '-u', '--url URL',
          'URL of the code review, repeat the argument for multiple URLs'
        ) do |url|
          urls << url
        end
      end

      def on_reviewer(parser)
        parser.on(
          '-r', '--reviewer',
          'Reviewer of the code review, repeat for multiple reviewers'
        ) do |reviewer|
          reviewers << reviewer if reviewers.length < 2
        end
      end

      def on_developer(parser)
        parser.on('-d', '--developer',
                  'Developer like @dave') do |developer|
          self.developer = developer
        end
      end

      def on_project(parser)
        parser.on('-p', '--project',
                  'Project like natlib') do |project|
          self.project = project
        end
      end

      def on_modal(parser)
        parser.on(
          '-m', '--modal', 'Show a modal (only CR)'
        ) do |modal|
          self.modal = modal
        end
      end

      def on_note(parser)
        parser.on('-n', '--note NOTE', 'Add note (only CR)') do |note|
          self.note = note
        end
      end

      def to_s
        puts <<~HELP
          action: #{action}
          object: #{object}
          urls: #{urls}
          reviewers: #{reviewers}
          developer: #{developer}
          project: #{project}
          modal: #{modal}
          note: #{note}
        HELP
      end
    end

    # Return a structure describing the options.
    def parse(args)
      # The options specified on the command line will be collected in
      # *options*.

      @options = RestOptions.new
      @args = OptionParser.new do |parser|
        @options.define_options(parser)
        parser.parse!(args)
      end
      @options
    end

    attr_reader :parser, :options
  end
end
