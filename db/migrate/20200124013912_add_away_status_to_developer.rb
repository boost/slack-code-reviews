class AddAwayStatusToDeveloper < ActiveRecord::Migration[6.0]
  def change
    add_column :developers, :away, :boolean, default: false
  end
end
