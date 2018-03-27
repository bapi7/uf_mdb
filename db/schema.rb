# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 0) do

  create_table "celebrities", primary_key: "celebrity_id", id: :string, limit: 10, force: :cascade do |t|
    t.string "celebrity_name", limit: 100, null: false
    t.string "birth_year",     limit: 5
    t.string "death_year",     limit: 5
    t.string "profession",     limit: 100
    t.string "known_for",      limit: 100
  end

  create_table "movies", primary_key: "movie_id", id: :string, limit: 10, force: :cascade do |t|
    t.string  "primary_title",    limit: 100,                null: false
    t.string  "original_title",   limit: 100,                null: false
    t.integer "start_year",                   precision: 38, null: false
    t.integer "run_time_minutes",             precision: 38, null: false
    t.string  "genres",           limit: 100,                null: false
  end

  create_table "ratings", primary_key: "movie_id", id: :string, limit: 10, force: :cascade do |t|
    t.float   "rating", limit: 126,                null: false
    t.integer "votes",              precision: 38, null: false
  end

  create_table "web_admin", primary_key: "user_id", force: :cascade do |t|
    t.string "user_position", limit: 100
    t.date   "join_date"
  end

  create_table "web_user", primary_key: "user_id", force: :cascade do |t|
    t.string "user_name",     limit: 100
    t.string "email_id",      limit: 100
    t.date   "date_of_birth"
    t.string "user_type",     limit: 50
    t.string "is_regestered", limit: 4
    t.string "is_admin",      limit: 4
  end

  add_foreign_key "ratings", "movies", primary_key: "movie_id", name: "sys_c00595581"
  add_foreign_key "web_admin", "web_user", column: "user_id", primary_key: "user_id", name: "sys_c00559886"
end
