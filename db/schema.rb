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

ActiveRecord::Schema.define(version: 20161224195702) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "students", force: :cascade do |t|
    t.string  "name",                       null: false
    t.string  "email",         default: "", null: false
    t.string  "phone_number"
    t.string  "subject"
    t.string  "activity_type"
    t.integer "user_id"
    t.index ["user_id"], name: "index_students_on_user_id", using: :btree
  end

  create_table "tutors", force: :cascade do |t|
    t.string  "subject",       null: false
    t.string  "activity_type", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_tutors_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "name",                           null: false
    t.string   "email",                          null: false
    t.string   "encrypted_password", limit: 128, null: false
    t.string   "confirmation_token", limit: 128
    t.string   "remember_token",     limit: 128, null: false
    t.string   "phone_number"
    t.string   "customer_id"
    t.string   "auth_provider"
    t.string   "auth_uid"
    t.string   "access_token"
    t.string   "refresh_token"
    t.integer  "token_expires_at"
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["remember_token"], name: "index_users_on_remember_token", using: :btree
  end

  add_foreign_key "students", "users"
  add_foreign_key "tutors", "users"
end
