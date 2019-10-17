# frozen_string_literal: true

class CreateSlackWorkspaces < ActiveRecord::Migration[6.0]
  def change
    create_table :slack_workspaces do |t|
      t.string :slack_workspace_id

      t.timestamps
    end
  end
end
