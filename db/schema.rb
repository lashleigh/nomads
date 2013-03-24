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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110319090241) do

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "position_id"
    t.string   "position_type"
    t.integer  "user_id"
  end

  create_table "flickr_photos", :force => true do |t|
    t.string   "title"
    t.integer  "farm"
    t.string   "secret"
    t.string   "photo_id"
    t.string   "server"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.float    "lat"
    t.float    "lon"
    t.string   "uploaded"
  end

  create_table "icons", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.float    "lat"
    t.float    "lon"
    t.integer  "user_id"
    t.boolean  "published",  :default => false
  end

  create_table "suggestions", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.float    "lat"
    t.float    "lon"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "icon_id"
    t.integer  "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "openid"
    t.string   "email"
    t.string   "fullname"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "admin"
    t.string   "link"
  end

  create_table "waypoints", :force => true do |t|
    t.integer  "prev_waypoint_id"
    t.integer  "position_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "position_type"
  end

end
