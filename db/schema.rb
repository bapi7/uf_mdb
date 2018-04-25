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

ActiveRecord::Schema.define(version: 20180425153949) do

  create_table "boxoffice", primary_key: "movie_id", id: :string, limit: 10, force: :cascade do |t|
    t.string "production", limit: 100
    t.string "boxoffice",  limit: 100
  end

  create_table "celebrities", primary_key: "celebrity_id", id: :string, limit: 10, force: :cascade do |t|
    t.string "celebrity_name", limit: 100, null: false
    t.string "birth_year",     limit: 5
    t.string "death_year",     limit: 5
    t.string "profession",     limit: 100
    t.string "known_for",      limit: 100
  end

  create_table "follows", primary_key: ["follower_id", "following_id"], force: :cascade do |t|
    t.integer "follower_id",  precision: 38, null: false
    t.integer "following_id", precision: 38, null: false
  end

  create_table "movies", primary_key: "movie_id", id: :string, limit: 10, force: :cascade do |t|
    t.string  "primary_title",    limit: 100,                 null: false
    t.string  "original_title",   limit: 100,                 null: false
    t.integer "start_year",                    precision: 38, null: false
    t.integer "run_time_minutes",              precision: 38, null: false
    t.string  "genres",           limit: 100,                 null: false
    t.string  "mpaa_rating",      limit: 10
    t.string  "plot",             limit: 1000
    t.string  "movie_language",   limit: 200
    t.string  "country",          limit: 200
    t.string  "awards",           limit: 200
    t.string  "poster",           limit: 1000
  end

  create_table "principal_cast", primary_key: ["movie_id", "celebrity_id"], force: :cascade do |t|
    t.string "movie_id",     limit: 10, null: false
    t.string "celebrity_id", limit: 10, null: false
    t.string "movie_role",   limit: 50
  end

  create_table "ratings", primary_key: "movie_id", id: :string, limit: 10, force: :cascade do |t|
    t.float   "rating", limit: 126,                null: false
    t.integer "votes",              precision: 38, null: false
  end

  create_table "reviews", primary_key: ["movie_id", "user_id"], force: :cascade do |t|
    t.string  "movie_id", limit: 10,                 null: false
    t.integer "user_id",              precision: 38, null: false
    t.string  "review",   limit: 500
    t.integer "rating",               precision: 38
  end

  create_table "users", primary_key: "user_id", force: :cascade do |t|
    t.string   "user_name",       limit: 100
    t.string   "email_id",        limit: 100
    t.date     "date_of_birth"
    t.string   "user_type",       limit: 50
    t.string   "is_registered",   limit: 4
    t.string   "is_admin",        limit: 4
    t.string   "password_digest"
    t.datetime "created_at",                  precision: 6
    t.datetime "updated_at",                  precision: 6
  end

  create_table "web_admin", primary_key: "user_id", force: :cascade do |t|
    t.string "user_position", limit: 100
    t.date   "join_date"
  end

  add_foreign_key "boxoffice", "movies", primary_key: "movie_id", name: "sys_c00600511"
  add_foreign_key "follows", "users", column: "follower_id", primary_key: "user_id", name: "sys_c00602003"
  add_foreign_key "follows", "users", column: "following_id", primary_key: "user_id", name: "sys_c00602004"
  add_foreign_key "principal_cast", "celebrities", primary_key: "celebrity_id", name: "sys_c00600885"
  add_foreign_key "principal_cast", "movies", primary_key: "movie_id", name: "sys_c00600884"
  add_foreign_key "ratings", "movies", primary_key: "movie_id", name: "sys_c00595581"
  add_foreign_key "reviews", "movies", primary_key: "movie_id", name: "sys_c00602000"
  add_foreign_key "reviews", "users", primary_key: "user_id", name: "sys_c00602001"
  add_foreign_key "web_admin", "users", primary_key: "user_id", name: "sys_c00559886"
end
