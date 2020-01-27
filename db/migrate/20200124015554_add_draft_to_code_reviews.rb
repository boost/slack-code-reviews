class AddDraftToCodeReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :code_reviews, :draft, :boolean, default: false
    add_column :code_reviews, :view_id, :string
  end
end
