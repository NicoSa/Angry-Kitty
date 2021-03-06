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

ActiveRecord::Schema.define(version: 20140619112520) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "debts", force: true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_harassed"
    t.boolean  "paid",          default: false
  end

  create_table "events", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "title"
    t.datetime "deadline"
    t.integer  "total"
    t.integer  "organiser_id"
    t.string   "angerlevel"
    t.integer  "payment_amount"
  end

  add_index "events", ["organiser_id"], name: "index_events_on_organiser_id", using: :btree

  create_table "events_userinvitees", id: false, force: true do |t|
    t.integer "event_id",       null: false
    t.integer "userinvitee_id", null: false
  end

  create_table "payments", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "userinvitees", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "name"
    t.string   "mobile"
    t.integer  "payment_amount"
    t.string   "twitterhandle"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mobile"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "twitterhandle"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
