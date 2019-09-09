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

ActiveRecord::Schema.define(version: 20190909181612) do

  create_table "actions", force: :cascade do |t|
    t.string "trello_id"
    t.datetime "datetime"
    t.string "type"
    t.string "change_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "trello_card_id"
    t.string "action_type"
  end

  create_table "cards", force: :cascade do |t|
    t.string "trello_id"
    t.string "name"
    t.string "current_trello_list_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "list_times", force: :cascade do |t|
    t.string "trello_card_id"
    t.decimal "hours_in_list"
    t.string "trello_list_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "enter"
    t.datetime "exit"
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

  create_table "trello_cards", force: :cascade do |t|
    t.string "name"
    t.string "trello_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "points"
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
  end

end
