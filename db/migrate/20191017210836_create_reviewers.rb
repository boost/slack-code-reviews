# frozen_string_literal: true

class CreateReviewers < ActiveRecord::Migration[6.0]
  def change
    create_table :reviewers do |t|
      t.belongs_to :developer
      t.belongs_to :code_review

      t.timestamps
    end
  end
end
