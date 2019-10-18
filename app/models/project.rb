# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :slack_workspace

  has_many :developers
end
