# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :developers
end
