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

ActiveRecord::Schema.define(version: 20140813142348) do

  create_table "submission_batches", force: true do |t|
    t.integer  "owner_id"
    t.string   "name"
    t.string   "media_type"
    t.string   "asset_family"
    t.boolean  "istock"
    t.string   "status"
    t.datetime "last_contribution_submitted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "submission_batches", ["owner_id"], name: "index_submission_batches_on_owner_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "account_id"
    t.string   "istock_account_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["account_id"], name: "index_users_on_account_id", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.string   "request_id"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  add_index "versions", ["whodunnit", "request_id"], name: "index_versions_on_whodunnit_and_request_id", using: :btree

end
