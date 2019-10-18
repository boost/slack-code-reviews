# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :name, unique: true

      t.belongs_to :slack_workspace

      t.timestamps
    end
  end
end
