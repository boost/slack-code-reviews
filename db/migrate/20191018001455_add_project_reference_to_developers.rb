# frozen_string_literal: true

class AddProjectReferenceToDevelopers < ActiveRecord::Migration[6.0]
  def change
    add_reference :developers, :project, foreign_key: true
  end
end
