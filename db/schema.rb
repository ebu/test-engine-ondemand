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

ActiveRecord::Schema.define(version: 20140225111754) do

  create_table "codem_notifications", force: true do |t|
    t.string   "status"
    t.decimal  "notified_at", precision: 15, scale: 3
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "codem_id"
    t.text     "message"
  end

  create_table "encoding_jobs", force: true do |t|
    t.string   "description"
    t.text     "post_processing_flags"
    t.integer  "status",                      default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "post_processing_template_id"
  end

  create_table "file_assets", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "resource_file_name"
    t.string   "resource_content_type"
    t.integer  "resource_file_size"
    t.datetime "resource_updated_at"
  end

  create_table "preset_templates", force: true do |t|
    t.text     "template_text"
    t.integer  "preset_type",   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  create_table "transcoders", force: true do |t|
    t.string   "host_name"
    t.integer  "port"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

end
