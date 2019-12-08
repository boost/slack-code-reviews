# frozen_string_literal: true

# A project is defined to assign developers in it
# This is done to enable a policy of having at least 1 code reviewer from the
# project picked up
class Project < ApplicationRecord
  belongs_to :slack_workspace

  has_many :developers
end
