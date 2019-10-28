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

ActiveRecord::Schema.define(version: 20191028185019) do

  create_table "board_configurations", force: :cascade do |t|
    t.string "config_type"
    t.string "value"
    t.integer "trello_board_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["config_type", "value", "trello_board_id"], name: "board_config", unique: true
  end

  create_table "burndown_configs", force: :cascade do |t|
    t.string "config_type"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "trello_board_id"
    t.integer "burndown_id"
  end

  create_table "burndowns", force: :cascade do |t|
    t.integer "trello_board_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "cards_per_week"
    t.index ["name", "trello_board_id"], name: "board_burndown"
  end

  create_table "events", force: :cascade do |t|
    t.datetime "event_date"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "trello_board_id"
  end

  create_table "trello_actions", force: :cascade do |t|
    t.string "trello_id"
    t.string "action_type"
    t.string "update_type"
    t.datetime "datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "trello_card_id"
  end

  create_table "trello_boards", force: :cascade do |t|
    t.string "trello_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_refresh"
    t.string "done_list_id"
    t.string "url"
  end

  create_table "trello_cards", force: :cascade do |t|
    t.string "name"
    t.string "trello_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "points"
    t.datetime "last_action_datetime"
    t.string "board_trello_id"
    t.string "board_name"
    t.integer "trello_board_id"
    t.string "card_type"
    t.string "trello_link"
    t.date "trello_create_date"
    t.string "state"
  end

  create_table "trello_cards_labels", id: false, force: :cascade do |t|
    t.integer "trello_card_id", null: false
    t.integer "trello_label_id", null: false
    t.index ["trello_card_id", "trello_label_id"], name: "card_label_join", unique: true
  end

  create_table "trello_credentials", force: :cascade do |t|
    t.string "trello_key"
    t.string "trello_token"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trello_labels", force: :cascade do |t|
    t.integer "trello_board_id"
    t.string "trello_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trello_list_changes", force: :cascade do |t|
    t.datetime "datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "trello_card_id"
    t.string "list_before"
    t.string "list_after"
    t.string "trello_action_ref_id"
    t.string "list_before_name"
    t.string "list_after_name"
    t.decimal "time_in_list"
  end

  create_table "trello_lists", force: :cascade do |t|
    t.string "trello_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "trello_board_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "trello_token"
    t.string "trello_key"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
