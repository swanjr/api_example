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

ActiveRecord::Schema.define(version: 20150427132848) do

  create_table "contributions", force: :cascade do |t|
    t.integer  "owner_id",            limit: 4,   null: false
    t.integer  "file_upload_id",      limit: 4,   null: false
    t.integer  "submission_batch_id", limit: 4
    t.integer  "contributable_id",    limit: 4,   null: false
    t.string   "contributable_type",  limit: 255, null: false
    t.string   "type",                limit: 255, null: false
    t.string   "status",              limit: 255, null: false
    t.string   "master_id",           limit: 255
    t.string   "istock_master_id",    limit: 255
    t.datetime "submitted_at"
    t.datetime "published_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "contributions", ["contributable_type", "contributable_id"], name: "index_contributions_on_contributable_type_and_contributable_id", using: :btree
  add_index "contributions", ["file_upload_id"], name: "index_contributions_on_file_upload_id", using: :btree
  add_index "contributions", ["istock_master_id"], name: "index_contributions_on_istock_master_id", using: :btree
  add_index "contributions", ["master_id"], name: "index_contributions_on_master_id", using: :btree
  add_index "contributions", ["owner_id"], name: "index_contributions_on_owner_id", using: :btree
  add_index "contributions", ["status"], name: "index_contributions_on_status", using: :btree
  add_index "contributions", ["submission_batch_id"], name: "index_contributions_on_submission_batch_id", using: :btree
  add_index "contributions", ["submitted_at"], name: "index_contributions_on_submitted_at", using: :btree
  add_index "contributions", ["type"], name: "index_contributions_on_type", using: :btree

  create_table "file_uploads", force: :cascade do |t|
    t.string   "name",                   limit: 255,   null: false
    t.string   "path",                   limit: 255
    t.string   "upload_bucket",          limit: 255
    t.string   "final_bucket",           limit: 255
    t.text     "external_file_location", limit: 65535
    t.string   "upload_id",              limit: 255
    t.string   "mime_type",              limit: 255
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "file_uploads", ["upload_id"], name: "index_file_uploads_on_upload_id", using: :btree

  create_table "submission_batches", force: :cascade do |t|
    t.integer  "owner_id",                       limit: 4,   null: false
    t.string   "allowed_contribution_type",      limit: 255, null: false
    t.string   "name",                           limit: 255, null: false
    t.string   "status",                         limit: 255, null: false
    t.datetime "last_contribution_submitted_at"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "submission_batches", ["allowed_contribution_type"], name: "index_submission_batches_on_allowed_contribution_type", using: :btree
  add_index "submission_batches", ["owner_id"], name: "index_submission_batches_on_owner_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",              limit: 255,                 null: false
    t.string   "account_number",        limit: 255,                 null: false
    t.string   "email",                 limit: 255,                 null: false
    t.string   "istock_username",       limit: 255
    t.string   "istock_account_number", limit: 255
    t.boolean  "enabled",               limit: 1,   default: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  add_index "users", ["account_number"], name: "index_users_on_account_number", using: :btree
  add_index "users", ["enabled"], name: "index_users_on_enabled", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

  add_foreign_key "contributions", "file_uploads", on_delete: :cascade
  add_foreign_key "contributions", "submission_batches", on_delete: :nullify
end
