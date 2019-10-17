# frozen_string_literal: true

class CreateCodeReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :code_reviews do |t|
      t.string :url
      t.belongs_to :slack_workspace

      t.timestamps
    end
  end
end
