class CreateCodeReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :code_reviews do |t|
      t.string :url
      t.belongs_to :team
      t.references :reviewer1, foreign_key: { to_table: 'developers' }
      t.references :reviewer2, foreign_key: { to_table: 'developers' }

      t.timestamps
    end
  end
end
