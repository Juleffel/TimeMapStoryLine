# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20131026184813) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "characters", force: true do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birth_date"
    t.string   "birth_place"
    t.boolean  "sex"
    t.string   "avatar_url"
    t.string   "avatar_name"
    t.string   "copyright"
    t.integer  "topic_id"
    t.text     "story"
    t.text     "resume"
    t.text     "small_rp"
    t.text     "anecdote"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "faction_id"
    t.integer  "group_id"
  end

  add_index "characters", ["topic_id"], name: "index_characters_on_topic_id", using: :btree
  add_index "characters", ["user_id"], name: "index_characters_on_user_id", using: :btree

  create_table "factions", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "color"
  end

  create_table "links", force: true do |t|
    t.integer  "from_character_id"
    t.integer  "to_character_id"
    t.string   "title"
    t.text     "description"
    t.integer  "force"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "links", ["from_character_id"], name: "index_links_on_from_character_id", using: :btree
  add_index "links", ["to_character_id"], name: "index_links_on_to_character_id", using: :btree

  create_table "nodes", force: true do |t|
    t.float    "longitude"
    t.float    "latitude"
    t.text     "title"
    t.text     "resume"
    t.datetime "begin_at"
    t.datetime "end_at"
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "nodes", ["topic_id"], name: "index_nodes_on_topic_id", using: :btree

  create_table "presences", force: true do |t|
    t.integer  "node_id"
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "presences", ["character_id"], name: "index_presences_on_character_id", using: :btree
  add_index "presences", ["node_id"], name: "index_presences_on_node_id", using: :btree

  create_table "topics", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
