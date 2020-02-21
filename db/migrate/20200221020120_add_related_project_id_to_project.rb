class AddRelatedProjectIdToProject < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :related_project_id, :integer
  end
end
