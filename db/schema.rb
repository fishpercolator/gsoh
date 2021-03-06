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

ActiveRecord::Schema.define(version: 20160520160510) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.string   "type"
    t.integer  "user_id"
    t.integer  "question_id"
    t.integer  "answer"
    t.string   "subtype"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["user_id"], name: "index_answers_on_user_id", using: :btree

  create_table "area_contained_ftypes", force: :cascade do |t|
    t.integer  "area_id"
    t.string   "ftype"
    t.string   "subtype"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "area_contained_ftypes", ["area_id"], name: "index_area_contained_ftypes_on_area_id", using: :btree

  create_table "areas", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float    "lat"
    t.float    "lng"
  end

  create_table "areas_features", force: :cascade do |t|
    t.integer "area_id"
    t.integer "feature_id"
  end

  add_index "areas_features", ["area_id"], name: "index_areas_features_on_area_id", using: :btree
  add_index "areas_features", ["feature_id"], name: "index_areas_features_on_feature_id", using: :btree

  create_table "features", force: :cascade do |t|
    t.string   "name"
    t.string   "ftype"
    t.string   "subtype"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "features", ["ftype", "subtype"], name: "index_features_on_ftype_and_subtype", using: :btree
  add_index "features", ["ftype"], name: "index_features_on_ftype", using: :btree

  create_table "matches", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "area_id"
    t.integer  "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "matches", ["area_id"], name: "index_matches_on_area_id", using: :btree
  add_index "matches", ["user_id"], name: "index_matches_on_user_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.string   "type"
    t.string   "text"
    t.string   "ftype"
    t.boolean  "ask_subtype"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "image_url"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: ""
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "admin"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.boolean  "needs_regeneration"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "users"
  add_foreign_key "area_contained_ftypes", "areas"
  add_foreign_key "areas_features", "areas"
  add_foreign_key "areas_features", "features"
  add_foreign_key "matches", "areas"
  add_foreign_key "matches", "users"
end
