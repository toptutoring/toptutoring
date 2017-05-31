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

ActiveRecord::Schema.define(version: 20170529221503) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "availabilities", force: :cascade do |t|
    t.datetime "from"
    t.datetime "to"
    t.integer  "engagement_id"
    t.index ["engagement_id"], name: "index_availabilities_on_engagement_id", using: :btree
  end

  create_table "client_infos", force: :cascade do |t|
    t.string  "subject"
    t.boolean "student"
    t.integer "user_id"
    t.string  "comments"
    t.index ["user_id"], name: "index_client_infos_on_user_id", using: :btree
  end

  create_table "contracts", force: :cascade do |t|
    t.integer  "hourly_rate",          default: 1500,  null: false
    t.integer  "user_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "hourly_rate_cents",    default: 1500,  null: false
    t.string   "hourly_rate_currency", default: "USD", null: false
    t.index ["user_id"], name: "index_contracts_on_user_id", using: :btree
  end

  create_table "emails", force: :cascade do |t|
    t.string   "subject"
    t.string   "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "tutor_id"
    t.integer  "client_id"
    t.index ["client_id"], name: "index_emails_on_client_id", using: :btree
    t.index ["tutor_id"], name: "index_emails_on_tutor_id", using: :btree
  end

  create_table "engagements", force: :cascade do |t|
    t.integer  "tutor_id"
    t.integer  "student_id"
    t.string   "state",         default: "pending", null: false
    t.string   "subject"
    t.string   "academic_type"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "client_id"
    t.string   "student_name"
    t.datetime "preferred_start_date"
    t.index ["client_id"], name: "index_engagements_on_client_id", using: :btree
    t.index ["student_id"], name: "index_engagements_on_student_id", using: :btree
    t.index ["tutor_id"], name: "index_engagements_on_tutor_id", using: :btree
  end

  create_table "feedbacks", force: :cascade do |t|
    t.text     "comments"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_feedbacks_on_user_id", using: :btree
  end

  create_table "funding_sources", force: :cascade do |t|
    t.string  "funding_source_id"
    t.integer "user_id"
    t.index ["user_id"], name: "index_funding_sources_on_user_id", using: :btree
  end

  create_table "invoices", force: :cascade do |t|
    t.integer  "tutor_id"
    t.integer  "engagement_id"
    t.decimal  "hours",         precision: 10, scale: 2, default: "0.0", null: false
    t.integer  "hourly_rate"
    t.integer  "amount"
    t.string   "description"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.integer  "status"
    t.string   "subject"
    t.integer  "client_id"
    t.index ["client_id"], name: "index_invoices_on_client_id", using: :btree
    t.index ["engagement_id"], name: "index_invoices_on_engagement_id", using: :btree
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

  create_table "roles", force: :cascade do |t|
    t.string "name"
  end

  create_table "student_infos", force: :cascade do |t|
    t.string  "subject"
    t.string  "academic_type"
    t.integer "user_id"
    t.index ["user_id"], name: "index_student_infos_on_user_id", using: :btree
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
  end

  create_table "tutor_profiles", force: :cascade do |t|
    t.integer "user_id"
    t.integer "subject_id"
    t.index ["subject_id"], name: "index_tutor_profiles_on_subject_id", using: :btree
    t.index ["user_id"], name: "index_tutor_profiles_on_user_id", using: :btree
  end

  create_table "user_roles", force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["role_id"], name: "index_user_roles_on_role_id", using: :btree
    t.index ["user_id"], name: "index_user_roles_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                                                                           null: false
    t.datetime "updated_at",                                                                           null: false
    t.string   "name",                                                                                 null: false
    t.string   "email"
    t.string   "encrypted_password",         limit: 128,                                               null: false
    t.string   "confirmation_token",         limit: 128
    t.string   "remember_token",             limit: 128,                                               null: false
    t.string   "phone_number"
    t.string   "customer_id"
    t.string   "auth_provider"
    t.string   "auth_uid"
    t.string   "encrypted_access_token"
    t.string   "encrypted_access_token_iv"
    t.string   "encrypted_refresh_token"
    t.string   "encrypted_refresh_token_iv"
    t.integer  "token_expires_at"
    t.string   "access_state",                                                    default: "disabled", null: false
    t.integer  "client_id"
    t.decimal  "academic_credit",                        precision: 10, scale: 2, default: "0.0",      null: false
    t.decimal  "test_prep_credit",                       precision: 10, scale: 2, default: "0.0",      null: false
    t.decimal  "outstanding_balance",                    precision: 10, scale: 2, default: "0.0",      null: false
    t.integer  "academic_rate_cents",                                             default: 2999,       null: false
    t.string   "academic_rate_currency",                                          default: "USD",      null: false
    t.integer  "test_prep_rate_cents",                                            default: 5999,       null: false
    t.string   "test_prep_rate_currency",                                         default: "USD",      null: false
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["remember_token"], name: "index_users_on_remember_token", using: :btree
  end

  add_foreign_key "availabilities", "engagements"
  add_foreign_key "client_infos", "users"
  add_foreign_key "contracts", "users"
  add_foreign_key "feedbacks", "users"
  add_foreign_key "payments", "users", column: "payee_id"
  add_foreign_key "payments", "users", column: "payer_id"
  add_foreign_key "student_infos", "users"
end
