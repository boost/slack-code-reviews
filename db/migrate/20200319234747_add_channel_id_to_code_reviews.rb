class AddChannelIdToCodeReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :code_reviews, :channel_id, :string, null: false
  end
end
