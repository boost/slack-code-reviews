module Slack
  class ArgumentParser
    def initialize(arguments = '')
      @arguments = arguments.split
    end

    def call
      options = OpenStruct.new
      opt_parser = OptionParser.new do |opts|
        opts.program_name = '/cr'
        opts.banner = 'Usage: /cr [options] [subcommand [options]]'
        opts.description = 'Code review command'
        opts.separator ''
        opts.separator 'Global options are:'
        opts.on('-n', '--new-review URL,DEVELOPER', Array, 'new code review') { |l| options.url = l[0]; options.developer = l[1] }
        opts.on('-a', '--add-developer DEVELOPER', 'add DEVELOPER') { |o| options.add_developer = o }
        opts.on('-d', '--delete-developer DEVELOPER', 'delete DEVELOPER') { |o| options.delete_developer = o }
        opts.on('-l', '--list-developers', 'list developers') { |o| options.list_developers = o }

        opts.on_tail('-h', '--help', 'Show this message') { |o| options.help = opts.to_s }
      end
      opt_parser.parse!(@arguments)
      puts options[:h] if options[:h].present?
      return options
    end
  end
end
