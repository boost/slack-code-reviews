class CreateDevelopers < ActiveRecord::Migration[6.0]
  def change
    create_table :developers do |t|
      t.string :name
      t.belongs_to :team

      t.timestamps
    end
  end
end
