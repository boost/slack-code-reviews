class AddNoteToCodeReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :code_reviews, :note, :string
  end
end
