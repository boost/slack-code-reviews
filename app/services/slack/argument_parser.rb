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
      attr_accessor :note, :attributes

      ACTION_LIST = %w[add get list delete set].freeze
      ACTION_ALIASES = {
        'a': 'add',
        'g': 'get',
        'l': 'list',
        'd': 'delete',
        'see': 'get',
        'index': 'list',
        'remove': 'delete',
        's': 'set'
      }.freeze

      OBJECT_LIST = %w[code-review developer project project-developer].freeze
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

      MANDATORY_OPTIONS = {
        developer_add: %i[unpersisted_developer],
        developer_get: %i[persisted_developer],
        developer_list: %i[],
        developer_delete: %i[persisted_developer],
        developer_set: %i[],

        project_add: %i[unpersisted_project],
        project_get: %i[persisted_project],
        project_list: %i[],
        project_delete: %i[persisted_project],

        project_developer_add: %i[persisted_project persisted_developer],
        project_developer_get: %i[persisted_project persisted_developer],
        project_developer_list: %i[],
        project_developer_delete: %i[persisted_project persisted_developer],

        code_review_add: %i[],
        code_review_get: %i[persisted_url],
        code_review_list: %i[],
        code_review_delete: %i[persisted_url]
      }.freeze

      def initialize(context)
        self.slack_workspace = context[:slack_workspace]
        self.requester = context[:sender]
        self.channel_id = context[:channel_id]
        self.message = nil
        self.action = 'add'
        self.object = 'code-review'
        self.urls = []
        self.reviewers = []
        self.developer = nil
        self.project = nil
        self.modal = false
        self.note = nil
        self.attributes = {}
      end

      def create_url(url_str)
        url = Url.new(url: url_str)
        url.sanitize_url
        unless url.merge_request?
          raise OptionParser::InvalidArgument,
                "#{url_str}: is not a valid merge request URL."
        end

        url
      end

      def find_developer(tag)
        dev = Developer.find_by(tag: tag)
        return dev if dev

        Developer.new(slack_workspace: slack_workspace, tag: tag)
      end

      def find_project(project_str)
        project = Project.find_by(
          name: project_str, slack_workspace: slack_workspace
        )
        return project if project

        Project.new(slack_workspace: slack_workspace, name: project_str)
      end

      def validate_options
        key = "#{object.tr('-', '_')}_#{action}".to_sym
        MANDATORY_OPTIONS[key].each do |option|
          option_name = option.match(/persisted_(.*)/)[1]
          option_value = send(option_name)
          if option_value.nil?
            raise OptionParser::MissingArgument, "#{option_name} is mandatory."
          end

          if option.to_s.match?(/^persisted/)
            unless option_value.persisted?

              raise OptionParser::InvalidArgument,
                    "The #{option_name} is not registered in the app.\n\
Please check `/cr -a list -o #{option_name}`"
            end

          elsif option_value.persisted?

            raise OptionParser::InvalidArgument,
                  "The #{option_name} is already in the app.\n\
Please check `/cr -a list -o #{option_name}`"

          end
        end
      end

      def enrich_options
        return unless action == 'add' && object == 'code-review' && urls.empty?

        self.modal = true
      end

      def define_accepts(parser)
        parser.accept(Url) { |url| create_url(url) }
        parser.accept(Developer) { |dev| find_developer(dev) }
        parser.accept(Project) { |project| find_project(project) }
      end

      def define_options(parser)
        parser.separator '```'
        parser.separator 'Usage: /cr [-a <action>] [-o <object>] [options]'

        parser.separator ''
        parser.separator 'ACTIONS:'
        on_action(parser)
        parser.separator "    Possible actions: #{ACTION_LIST.join(', ')}"

        parser.separator ''
        parser.separator 'OBJECTS:'
        on_object(parser)
        parser.separator "    Possible objects: #{OBJECT_LIST.join(', ')}"

        parser.separator ''
        parser.separator 'OPTIONS:'
        on_url(parser)
        on_note(parser)
        on_reviewer(parser)
        on_developer(parser)
        on_project(parser)
        on_modal(parser)
        on_set(parser)

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
        parser.separator '        Add:           /cr -a add    -o developer -d @dave'
        parser.separator '        List:          /cr -a list   -o developer'
        parser.separator '        Get:           /cr -a get    -o developer -d @dave'
        parser.separator '        Remove:        /cr -a delete -o developer -d @dave'
        parser.separator '        Set away:      /cr -a set    -o developer -d @dave --away' 
        parser.separator '        Set available: /cr -a set    -o developer -d @dave --available' 
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
          '-a', '--action ACTION', ACTION_LIST, ACTION_ALIASES,
          'Action you would like to be executed, defaults to add'
        ) do |action|
          self.action = action
        end
      end

      def on_object(parser)
        # Specifies an optional option argument
        parser.on(
          '-o', '--object OBJECT', OBJECT_LIST, OBJECT_ALIASES,
          'The object you want to act on, defaults to code-review'
        ) do |object|
          self.object = object
        end
      end

      def on_url(parser)
        # Specifies an optional option argument
        parser.on(
          '-u', '--url URL', Url,
          'URL of the code review, repeat the argument for multiple URLs'
        ) do |url|
          urls << url
        end
      end

      def on_reviewer(parser)
        parser.on(
          '-r', '--reviewer REVIEWER', Developer,
          'Reviewer of the code review, repeat for multiple reviewers'
        ) do |reviewer|
          reviewers << reviewer if reviewers.length < 2
        end
      end

      def on_developer(parser)
        parser.on('-d', '--developer DEVELOPER', Developer,
                  'Developer like @dave') do |developer|
          self.developer = developer
        end
      end

      def on_project(parser)
        parser.on('-p', '--project PROJECT', Project,
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

      def on_set(parser)
        parser.on('--away', 'Set away') do
          self.attributes[:away] = true
        end

        parser.on('--available', 'Set available') do
          self.attributes[:away] = false
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
    def parse(args, context)
      # The options specified on the command line will be collected in
      # *options*.

      @options = RestOptions.new(context)
      @args = OptionParser.new do |parser|
        @options.define_accepts(parser)

        @options.define_options(parser)
        parser.parse!(args)

        @options.validate_options
        @options.enrich_options
      end

      @options
    end

    attr_reader :parser, :options
  end
end
