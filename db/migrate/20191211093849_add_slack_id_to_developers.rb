class AddSlackIdToDevelopers < ActiveRecord::Migration[6.0]
  def change
    add_column :developers, :slack_id, :string, unique: true
    add_column :developers, :avatar_url, :string
  end
end
