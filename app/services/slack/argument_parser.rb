# frozen_string_literal: true

module Slack
  class ArgumentParser
    def initialize(arguments = '')
      @arguments = arguments.split

      @options = OpenStruct.new
      @opt_parser = OptionParser.new do |opts|
        opts.program_name = '/cr'
        opts.banner = 'Usage: /cr [options] [subcommand [options]]'
        opts.separator ''
        opts.separator 'Global options are:'
        opts.on('-n', '--new-review URL,DEVELOPER', Array, 'new code review') { |l| @options.list = l }
        opts.on('-a', '--add-developer DEVELOPER', 'add DEVELOPER') { |o| @options.add_developer = o }
        opts.on('-d', '--delete-developer DEVELOPER', 'delete DEVELOPER') { |o| @options.delete_developer = o }
        opts.on('-l', '--list-developers', 'list developers') { |o| @options.list_developers = o }

        opts.on_tail('-h', '--help', 'Show this message') { |o| @options.help = opts.to_s }
      end
    end

    def call
      @opt_parser.parse!(@arguments)
      @options
    rescue OptionParser::InvalidOption
      @options.help = @opt_parser.help
      @options
    end
  end
end
