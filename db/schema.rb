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

ActiveRecord::Schema[8.1].define(version: 2026_08_12_005040) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "cards", force: :cascade do |t|
    t.string "category", null: false
    t.string "clue", null: false
    t.datetime "created_at", null: false
    t.text "fact", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "room_id", null: false
    t.integer "score", default: 0, null: false
    t.string "seat", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id", "seat"], name: "index_players_on_room_id_and_seat", unique: true
    t.index ["room_id"], name: "index_players_on_room_id"
    t.index ["token"], name: "index_players_on_token", unique: true
  end

  create_table "rooms", force: :cascade do |t|
    t.boolean "clue_revealed"
    t.string "code"
    t.datetime "created_at", null: false
    t.bigint "current_card_id"
    t.bigint "drawer_player_id"
    t.bigint "guesser_player_id"
    t.datetime "round_started_at"
    t.string "round_status"
    t.string "status"
    t.datetime "updated_at", null: false
    t.integer "used_card_ids", default: [], array: true
    t.index ["code"], name: "index_rooms_on_code", unique: true
    t.index ["current_card_id"], name: "index_rooms_on_current_card_id"
    t.index ["drawer_player_id"], name: "index_rooms_on_drawer_player_id"
    t.index ["guesser_player_id"], name: "index_rooms_on_guesser_player_id"
  end

  add_foreign_key "players", "rooms"
  add_foreign_key "rooms", "cards", column: "current_card_id"
  add_foreign_key "rooms", "players", column: "drawer_player_id"
  add_foreign_key "rooms", "players", column: "guesser_player_id"
end
