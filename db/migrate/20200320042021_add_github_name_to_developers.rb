class AddGithubNameToDevelopers < ActiveRecord::Migration[6.0]
  def change
    add_column :developers, :github_name, :string
  end
end
