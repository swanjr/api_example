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

ActiveRecord::Schema.define(version: 20150916114405) do

  create_table "contributions", force: :cascade do |t|
    t.integer  "owner_id",            limit: 4,   null: false
    t.integer  "file_info_id",        limit: 4
    t.integer  "submission_batch_id", limit: 4
    t.integer  "media_id",            limit: 4,   null: false
    t.string   "media_type",          limit: 255, null: false
    t.string   "type",                limit: 255, null: false
    t.string   "status",              limit: 255, null: false
    t.string   "master_id",           limit: 255
    t.string   "istock_master_id",    limit: 255
    t.datetime "submitted_at"
    t.datetime "published_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "contributions", ["file_info_id"], name: "index_contributions_on_file_info_id", using: :btree
  add_index "contributions", ["istock_master_id"], name: "index_contributions_on_istock_master_id", using: :btree
  add_index "contributions", ["master_id"], name: "index_contributions_on_master_id", using: :btree
  add_index "contributions", ["media_type", "media_id"], name: "index_contributions_on_media_type_and_media_id", using: :btree
  add_index "contributions", ["owner_id"], name: "contributions_owner_id_fk", using: :btree
  add_index "contributions", ["status"], name: "index_contributions_on_status", using: :btree
  add_index "contributions", ["submission_batch_id"], name: "index_contributions_on_submission_batch_id", using: :btree
  add_index "contributions", ["submitted_at"], name: "index_contributions_on_submitted_at", using: :btree
  add_index "contributions", ["type"], name: "index_contributions_on_type", using: :btree

  create_table "file_info", force: :cascade do |t|
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

  add_index "file_info", ["upload_id"], name: "index_file_info_on_upload_id", using: :btree

  create_table "group_permissions", id: false, force: :cascade do |t|
    t.integer "group_id",      limit: 4, null: false
    t.integer "permission_id", limit: 4, null: false
  end

  add_index "group_permissions", ["group_id", "permission_id"], name: "index_group_permissions_on_group_id_and_permission_id", unique: true, using: :btree
  add_index "group_permissions", ["permission_id"], name: "fk_rails_7605882dbf", using: :btree

  create_table "group_users", id: false, force: :cascade do |t|
    t.integer "group_id", limit: 4, null: false
    t.integer "user_id",  limit: 4, null: false
  end

  add_index "group_users", ["group_id", "user_id"], name: "index_group_users_on_group_id_and_user_id", unique: true, using: :btree
  add_index "group_users", ["user_id"], name: "fk_rails_1486913327", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "groups", ["name"], name: "index_groups_on_name", using: :btree

  create_table "permissions", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "permissions", ["name"], name: "index_permissions_on_name", using: :btree

  create_table "submission_batches", force: :cascade do |t|
    t.integer  "owner_id",                       limit: 4,                  null: false
    t.string   "allowed_contribution_type",      limit: 255,                null: false
    t.string   "name",                           limit: 255,                null: false
    t.string   "status",                         limit: 255,                null: false
    t.datetime "last_contribution_submitted_at"
    t.boolean  "apply_extracted_metadata",       limit: 1,   default: true
    t.string   "event_id",                       limit: 255
    t.string   "brief_id",                       limit: 255
    t.string   "assignment_id",                  limit: 255
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
  end

  add_index "submission_batches", ["allowed_contribution_type"], name: "index_submission_batches_on_allowed_contribution_type", using: :btree
  add_index "submission_batches", ["owner_id"], name: "submission_batches_owner_id_fk", using: :btree

  create_table "user_permissions", id: false, force: :cascade do |t|
    t.integer "user_id",       limit: 4, null: false
    t.integer "permission_id", limit: 4, null: false
  end

  add_index "user_permissions", ["permission_id"], name: "fk_rails_e2cb0687d2", using: :btree
  add_index "user_permissions", ["user_id", "permission_id"], name: "index_user_permissions_on_user_id_and_permission_id", unique: true, using: :btree

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

  create_table "videos", force: :cascade do |t|
    t.integer  "preview_id",                 limit: 4
    t.integer  "thumbnail_id",               limit: 4
    t.string   "poster_time",                limit: 255
    t.string   "extracted_poster_time",      limit: 255
    t.boolean  "video_encoding_timeout",     limit: 1,     default: false
    t.string   "headline",                   limit: 255
    t.datetime "recorded_date"
    t.text     "caption",                    limit: 65535
    t.string   "city",                       limit: 255
    t.string   "province_state",             limit: 255
    t.string   "country_of_shoot",           limit: 255
    t.string   "preferred_license_model",    limit: 255
    t.string   "copyright",                  limit: 255
    t.string   "collection_code",            limit: 255
    t.string   "clip_length",                limit: 255
    t.string   "frame_composition",          limit: 255
    t.string   "frame_rate",                 limit: 255
    t.string   "frame_size",                 limit: 255
    t.string   "mastered_to_compression",    limit: 255
    t.string   "media_format",               limit: 255
    t.string   "original_frame_composition", limit: 255
    t.string   "original_frame_rate",        limit: 255
    t.string   "original_frame_size",        limit: 255
    t.string   "original_media_format",      limit: 255
    t.string   "shot_speed",                 limit: 255
    t.string   "clip_type",                  limit: 255
    t.string   "original_production_title",  limit: 255
    t.string   "language",                   limit: 255
    t.string   "content_provider_name",      limit: 255
    t.string   "content_provider_title",     limit: 255
    t.string   "parent_source",              limit: 255
    t.string   "source_code",                limit: 255
    t.string   "credit_line",                limit: 255
    t.string   "visual_color",               limit: 255
    t.string   "risk_category",              limit: 255
    t.integer  "rank",                       limit: 4,     default: 3
    t.string   "alternate_id",               limit: 255
    t.string   "pixel_aspect_ratio",         limit: 255
    t.string   "event_id",                   limit: 255
    t.string   "iptc_category",              limit: 255
    t.string   "iptc_subject",               limit: 255
    t.text     "iptc_subjects",              limit: 65535
    t.boolean  "audio",                      limit: 1
    t.boolean  "call_for_image",             limit: 1,     default: false
    t.boolean  "exclusive_to_getty",         limit: 1,     default: false
    t.text     "personality",                limit: 65535
    t.text     "special_instructions",       limit: 65535
    t.text     "content_warnings",           limit: 65535
    t.boolean  "adult_content",              limit: 1
  end

  add_index "videos", ["preview_id"], name: "videos_preview_id_fk", using: :btree
  add_index "videos", ["thumbnail_id"], name: "videos_thumbnail_id_fk", using: :btree

  add_foreign_key "contributions", "file_info", on_delete: :nullify
  add_foreign_key "contributions", "submission_batches", on_delete: :nullify
  add_foreign_key "contributions", "users", column: "owner_id", name: "contributions_owner_id_fk"
  add_foreign_key "group_permissions", "groups", on_delete: :cascade
  add_foreign_key "group_permissions", "permissions", on_delete: :cascade
  add_foreign_key "group_users", "groups", on_delete: :cascade
  add_foreign_key "group_users", "users", on_delete: :cascade
  add_foreign_key "submission_batches", "users", column: "owner_id", name: "submission_batches_owner_id_fk"
  add_foreign_key "user_permissions", "permissions", on_delete: :cascade
  add_foreign_key "user_permissions", "users", on_delete: :cascade
  add_foreign_key "videos", "file_info", column: "preview_id", name: "videos_preview_id_fk", on_delete: :nullify
  add_foreign_key "videos", "file_info", column: "thumbnail_id", name: "videos_thumbnail_id_fk", on_delete: :nullify
end
