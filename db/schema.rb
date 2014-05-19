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

ActiveRecord::Schema.define(version: 20140516094541) do

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
  end

  create_table "scholar_queries", force: true do |t|
    t.text     "query_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "satisfaction"
    t.integer  "broadness"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.text     "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
