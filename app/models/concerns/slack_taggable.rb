# frozen_string_literal: true

# This can be used for models having a slack_id and name
# They MUST define the methods `slack_id` and `name` and call tag_character
# Example in `app/models/developer.rb`
module SlackTaggable
  extend ActiveSupport::Concern

  included do
    class_attribute :tag_c

    # tag format for a user <@U1234|user>
    # tag format for a channel <#C1234|channel>
    def initialize(opts)
      if opts[:tag].nil?
        super(opts)
      else
        slack_id, name = self.class.extract_from_tag(opts.delete(:tag))
        super(opts.merge(slack_id: slack_id, name: name))
      end
    end
  end

  class_methods do
    def find_by(opts)
      return super(opts) if opts[:tag].nil?

      slack_id, name = extract_from_tag(opts.delete(:tag))
      super(opts.merge(slack_id: slack_id, name: name))
    end

    def extract_from_tag(tag)
      regex = /^<#{tag_c}(.*)\|(.*)>$/
      raise ArgumentError, 'No tag given' unless tag.present?
      raise ArgumentError, "#{tag} has a wrong format" unless tag.match(regex)

      tag.scan(regex).flatten
    end

    def tag_character(character)
      self.tag_c = character
    end
  end

  def tag
    "<#{self.class.tag_c}#{slack_id}|#{name}>"
  end
end
