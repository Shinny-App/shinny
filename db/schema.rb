# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_22_000009) do
  create_table "games", force: :cascade do |t|
    t.integer "away_score"
    t.integer "away_team_id", null: false
    t.datetime "created_at", null: false
    t.integer "home_score"
    t.integer "home_team_id", null: false
    t.integer "league_id", null: false
    t.integer "location_id"
    t.datetime "rsvp_deadline"
    t.datetime "scheduled_at", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["away_team_id"], name: "index_games_on_away_team_id"
    t.index ["home_team_id"], name: "index_games_on_home_team_id"
    t.index ["league_id"], name: "index_games_on_league_id"
    t.index ["location_id"], name: "index_games_on_location_id"
  end

  create_table "leagues", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.integer "default_location_id"
    t.text "description"
    t.integer "league_type", default: 0, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["default_location_id"], name: "index_leagues_on_default_location_id"
  end

  create_table "locations", force: :cascade do |t|
    t.text "address"
    t.datetime "created_at", null: false
    t.integer "league_id", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_locations_on_league_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "role", default: 0, null: false
    t.integer "team_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["team_id"], name: "index_memberships_on_team_id"
    t.index ["user_id", "team_id"], name: "index_memberships_on_user_id_and_team_id", unique: true
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "rsvps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "game_id", null: false
    t.datetime "responded_at", null: false
    t.integer "response", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["game_id"], name: "index_rsvps_on_game_id"
    t.index ["user_id", "game_id"], name: "index_rsvps_on_user_id_and_game_id", unique: true
    t.index ["user_id"], name: "index_rsvps_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "league_id", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_teams_on_league_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "display_name", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "games", "leagues"
  add_foreign_key "games", "locations"
  add_foreign_key "games", "teams", column: "away_team_id"
  add_foreign_key "games", "teams", column: "home_team_id"
  add_foreign_key "leagues", "locations", column: "default_location_id"
  add_foreign_key "locations", "leagues"
  add_foreign_key "memberships", "teams"
  add_foreign_key "memberships", "users"
  add_foreign_key "rsvps", "games"
  add_foreign_key "rsvps", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "teams", "leagues"
end
