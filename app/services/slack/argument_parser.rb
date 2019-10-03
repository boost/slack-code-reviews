module Slack
  class ArgumentParser
    def initialize(options = '')
      @arguments = options.split
    end

    def call

      return 'error'
    end
  end
end
