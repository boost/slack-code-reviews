# frozen_string_literal: true

require 'test_helper'

class DeveloperTest < ActiveSupport::TestCase
  test 'should not save a developer without name' do
    developer = Developer.new(
      slack_workspace: SlackWorkspace.create(slack_workspace_id: 'ABC')
    )
    assert_not developer.save, 'Saved a developer without a title'
  end
end
