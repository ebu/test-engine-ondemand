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

ActiveRecord::Schema.define(version: 20140324151347) do

  create_table "codem_notifications", force: true do |t|
    t.string   "status"
    t.decimal  "notified_at", precision: 15, scale: 3
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "codem_id"
    t.text     "message"
  end

  add_index "codem_notifications", ["codem_id"], name: "index_codem_notifications_on_codem_id", using: :btree
  add_index "codem_notifications", ["notified_at"], name: "index_codem_notifications_on_notified_at", using: :btree
  add_index "codem_notifications", ["status"], name: "index_codem_notifications_on_status", using: :btree

  create_table "encoding_jobs", force: true do |t|
    t.string   "description"
    t.text     "post_processing_flags"
    t.integer  "status",                      default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "post_processing_template_id"
    t.integer  "post_processing_job_id"
    t.integer  "conformance_checking_job_id"
    t.string   "random_id"
    t.integer  "user_id"
    t.boolean  "is_reference",                default: false, null: false
  end

  add_index "encoding_jobs", ["created_at"], name: "index_encoding_jobs_on_created_at", using: :btree
  add_index "encoding_jobs", ["is_reference"], name: "index_encoding_jobs_on_is_reference", using: :btree
  add_index "encoding_jobs", ["status"], name: "index_encoding_jobs_on_status", using: :btree

  create_table "file_assets", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "resource_file_name"
    t.string   "resource_content_type"
    t.integer  "resource_file_size"
    t.datetime "resource_updated_at"
    t.integer  "user_id"
    t.boolean  "is_reference",          default: false, null: false
  end

  add_index "file_assets", ["created_at"], name: "index_file_assets_on_created_at", using: :btree
  add_index "file_assets", ["is_reference"], name: "index_file_assets_on_is_reference", using: :btree

  create_table "organizations", force: true do |t|
    t.string   "name",                       null: false
    t.integer  "ebu_id",                     null: false
    t.boolean  "can_write",  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "preset_templates", force: true do |t|
    t.text     "template_text"
    t.integer  "preset_type",   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.integer  "user_id"
    t.boolean  "is_reference",  default: false, null: false
  end

  add_index "preset_templates", ["is_reference"], name: "index_preset_templates_on_is_reference", using: :btree
  add_index "preset_templates", ["preset_type"], name: "index_preset_templates_on_preset_type", using: :btree
  add_index "preset_templates", ["user_id"], name: "index_preset_templates_on_user_id", using: :btree

  create_table "remote_jobs", force: true do |t|
    t.string   "remote_id"
    t.text     "stderr"
    t.text     "stdout"
    t.integer  "code"
    t.string   "command"
    t.text     "arguments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "remote_jobs", ["remote_id"], name: "index_remote_jobs_on_remote_id", using: :btree

  create_table "transcoders", force: true do |t|
    t.string   "host_name"
    t.integer  "port"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.integer  "ebu_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "organization_name"
    t.integer  "organization_id"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["ebu_id"], name: "index_users_on_ebu_id", using: :btree
  add_index "users", ["organization_id"], name: "index_users_on_organization_id", using: :btree

  create_table "variant_jobs", force: true do |t|
    t.integer  "encoding_job_id"
    t.integer  "encoder_preset_template_id"
    t.integer  "source_file_id"
    t.string   "source_file_path"
    t.string   "encoder_flags"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",                     default: 0
    t.string   "codem_id"
    t.integer  "transcoder_id"
    t.string   "destination_file_path"
  end

  add_index "variant_jobs", ["codem_id"], name: "index_variant_jobs_on_codem_id", using: :btree
  add_index "variant_jobs", ["encoding_job_id"], name: "index_variant_jobs_on_encoding_job_id", using: :btree

end
