# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_191_004_012_007) do
  create_table 'code_reviews', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'url'
    t.bigint 'team_id'
    t.bigint 'reviewer1_id'
    t.bigint 'reviewer2_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['reviewer1_id'], name: 'index_code_reviews_on_reviewer1_id'
    t.index ['reviewer2_id'], name: 'index_code_reviews_on_reviewer2_id'
    t.index ['team_id'], name: 'index_code_reviews_on_team_id'
  end

  create_table 'developers', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'name'
    t.bigint 'team_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['team_id'], name: 'index_developers_on_team_id'
  end

  create_table 'teams', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'team_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  add_foreign_key 'code_reviews', 'developers', column: 'reviewer1_id'
  add_foreign_key 'code_reviews', 'developers', column: 'reviewer2_id'
end
