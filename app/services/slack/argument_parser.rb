# frozen_string_literal: true

module Slack
  class ArgumentParser
    def initialize(args)
      @args = args
      @options = OpenStruct.new
      parse_crud
      parse_resource
      parse_args
    end

    def call
      return @options
    end

  private
    def parse_crud
      @options.crud = @args.shift
      @options.help = help unless %w[get add remove list].include?(@options.crud)
    end

    def parse_resource
      @options.resource = @args.shift
      @options.help = help unless %w[developer project code-review].include?(@options.resource)
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
    end

    def help
      <<~EOF
      /cr
        help

        get developer <@developer>
        add developer <@developer>
        remove developer <@developer>
        list developer

        get project <@project>
        add project <@project>
        remove project <@project>
        list project

        get code-review <@code_review_url>
        add code-review <@url> [-cr <@develper>]...
        list code-review
      EOF
    end
  end
end
