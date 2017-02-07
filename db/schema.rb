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

ActiveRecord::Schema.define(version: 20170206223221) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.integer  "tutor_id"
    t.integer  "student_id"
    t.string   "state",         default: "pending", null: false
    t.string   "subject"
    t.string   "academic_type"
    t.integer  "hourly_rate"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["student_id"], name: "index_assignments_on_student_id", using: :btree
    t.index ["tutor_id"], name: "index_assignments_on_tutor_id", using: :btree
  end

  create_table "invoices", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "tutor_id"
    t.integer  "assignment_id"
    t.integer  "hours"
    t.integer  "hourly_rate"
    t.integer  "amount"
    t.string   "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["assignment_id"], name: "index_invoices_on_assignment_id", using: :btree
    t.index ["student_id"], name: "index_invoices_on_student_id", using: :btree
    t.index ["tutor_id"], name: "index_invoices_on_tutor_id", using: :btree
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "amount"
    t.string   "description"
    t.string   "status"
    t.string   "source"
    t.string   "destination"
    t.string   "external_code"
    t.string   "customer_id"
    t.integer  "payer_id"
    t.integer  "payee_id"
    t.datetime "created_at"
    t.index ["payee_id"], name: "index_payments_on_payee_id", using: :btree
    t.index ["payer_id"], name: "index_payments_on_payer_id", using: :btree
  end

  create_table "students", force: :cascade do |t|
    t.string  "name"
    t.string  "email"
    t.string  "phone_number"
    t.string  "subject"
    t.string  "academic_type"
    t.integer "user_id"
    t.index ["user_id"], name: "index_students_on_user_id", using: :btree
  end

  create_table "tutors", force: :cascade do |t|
    t.string  "subject"
    t.string  "academic_type"
    t.integer "user_id"
    t.boolean "director",      default: false, null: false
    t.index ["user_id"], name: "index_tutors_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.string   "name",                                                        null: false
    t.string   "email",                                                       null: false
    t.string   "encrypted_password",         limit: 128,                      null: false
    t.string   "confirmation_token",         limit: 128
    t.string   "remember_token",             limit: 128,                      null: false
    t.string   "phone_number"
    t.string   "customer_id"
    t.string   "auth_provider"
    t.string   "auth_uid"
    t.string   "encrypted_access_token"
    t.string   "encrypted_access_token_iv"
    t.string   "encrypted_refresh_token"
    t.string   "encrypted_refresh_token_iv"
    t.integer  "token_expires_at"
    t.boolean  "admin",                                  default: false,      null: false
    t.string   "access_state",                           default: "disabled", null: false
    t.integer  "balance",                                default: 0,          null: false
    t.boolean  "demo",                                   default: false,      null: false
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["remember_token"], name: "index_users_on_remember_token", using: :btree
  end

  add_foreign_key "payments", "users", column: "payee_id"
  add_foreign_key "payments", "users", column: "payer_id"
  add_foreign_key "students", "users"
  add_foreign_key "tutors", "users"
end
