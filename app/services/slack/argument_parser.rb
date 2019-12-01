# frozen_string_literal: true

module Slack
  class ArgumentParser
    def initialize(args)
      @args = args
      @options = OpenStruct.new(help: help)
      if @args.find { |item| ['help', '--help', '-h'].include?(item) }
        @options.show_help = true
      else
        parse_crud
        parse_resource
        parse_args
      end
    end

    def call
      return @options
    end

  private
    def parse_crud
      @options.crud = @args.shift
    end

    def parse_resource
      @options.resource = @args.shift
    end

    def parse_args
      if %w[get add remove].include?(@options.crud) && @options.resource == 'developer'
        @options.developer = @args.shift
      end

      if %w[get add remove].include?(@options.crud) && @options.resource == 'code-review'
        @options.url = @args.shift
        @options.reviewers = @args
      end

      if %w[get add remove].include?(@options.crud) && @options.resource == 'project'
        @options.project = @args.shift
      end

      if %w[get add remove].include?(@options.crud) && @options.resource == 'project-developer'
        @options.project = @args.shift
        @options.developer = @args.shift
      end
    end

    def help
      <<~EOF
      /cr
        --help, -h, help

        get developer <@developer>
        add developer <@developer>
        remove developer <@developer>
        list developer

        get project <project>
        add project <project>
        remove project <project>
        list project

        get project-developer <project> <@developer>
        add project-developer <project> <@developer>
        remove project-developer <project> <@developer>
        list project-developer <project> <@developer>

        get code-review <url>
        add code-review <url> [<@developer>]...
        remove code-review <url> [<@developer>]...
        list code-review
      EOF
    end
  end
end
