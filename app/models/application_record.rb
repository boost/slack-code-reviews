# frozen_string_literal: true

# This is the base class for all the models, you can defined some defaults here
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
