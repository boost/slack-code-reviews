class AddRequesterToCodeReviews < ActiveRecord::Migration[6.0]
  def change
    add_reference :code_reviews,
                  :requester,
                  foreign_key: { to_table: :developers }
  end
end
