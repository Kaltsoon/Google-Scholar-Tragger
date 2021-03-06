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

ActiveRecord::Schema.define(version: 20140826054143) do

  create_table "admins", force: true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "query_clicks", force: true do |t|
    t.integer  "scholar_query_id"
    t.text     "heading"
    t.text     "synopsis"
    t.text     "link_location"
    t.integer  "sitations"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location"
    t.text     "authors"
    t.datetime "end_time"
    t.datetime "click_time"
  end

  create_table "query_scrolls", force: true do |t|
    t.integer  "scholar_query_id"
    t.integer  "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "scroll_time"
    t.integer  "start_position"
    t.integer  "end_position"
    t.datetime "start_time"
    t.datetime "end_time"
  end

  create_table "scholar_queries", force: true do |t|
    t.text     "query_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "satisfaction"
    t.integer  "broadness"
    t.integer  "task_report_id"
    t.datetime "query_time"
  end

  create_table "task_reports", force: true do |t|
    t.integer  "task_id"
    t.integer  "scholar_query_id"
    t.text     "report"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.datetime "completed"
    t.datetime "started"
    t.integer  "item_height"
    t.integer  "form_height"
    t.integer  "items"
  end

  create_table "tasks", force: true do |t|
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "title"
    t.text     "task_type"
    t.text     "task_code"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.text     "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
