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

ActiveRecord::Schema.define(version: 20170918235316) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "availabilities", id: :serial, force: :cascade do |t|
    t.datetime "from"
    t.datetime "to"
    t.integer "engagement_id"
    t.index ["engagement_id"], name: "index_availabilities_on_engagement_id"
  end

  create_table "contracts", id: :serial, force: :cascade do |t|
    t.integer "hourly_rate", default: 1500, null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "hourly_rate_cents", default: 1500, null: false
    t.string "hourly_rate_currency", default: "USD", null: false
    t.index ["user_id"], name: "index_contracts_on_user_id"
  end

  create_table "emails", id: :serial, force: :cascade do |t|
    t.string "subject"
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tutor_id"
    t.integer "client_id"
    t.index ["client_id"], name: "index_emails_on_client_id"
    t.index ["tutor_id"], name: "index_emails_on_tutor_id"
  end

  create_table "engagements", id: :serial, force: :cascade do |t|
    t.integer "tutor_id"
    t.integer "student_id"
    t.string "state", default: "pending", null: false
    t.string "subject"
    t.string "academic_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "client_id"
    t.string "student_name"
    t.datetime "preferred_start_date"
    t.index ["client_id"], name: "index_engagements_on_client_id"
    t.index ["student_id"], name: "index_engagements_on_student_id"
    t.index ["tutor_id"], name: "index_engagements_on_tutor_id"
  end

  create_table "feedbacks", id: :serial, force: :cascade do |t|
    t.text "comments"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "funding_sources", id: :serial, force: :cascade do |t|
    t.string "funding_source_id"
    t.integer "user_id"
    t.index ["user_id"], name: "index_funding_sources_on_user_id"
  end

  create_table "invoices", id: :serial, force: :cascade do |t|
    t.integer "tutor_id"
    t.integer "engagement_id"
    t.decimal "hours", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "hourly_rate"
    t.integer "amount"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.string "subject"
    t.integer "client_id"
    t.integer "tutor_pay_cents"
    t.index ["client_id"], name: "index_invoices_on_client_id"
    t.index ["engagement_id"], name: "index_invoices_on_engagement_id"
    t.index ["tutor_id"], name: "index_invoices_on_tutor_id"
  end

  create_table "payments", id: :serial, force: :cascade do |t|
    t.integer "amount_in_cents"
    t.string "description"
    t.string "status"
    t.string "source"
    t.string "destination"
    t.string "external_code"
    t.string "customer_id"
    t.integer "payer_id"
    t.integer "payee_id"
    t.datetime "created_at"
    t.index ["payee_id"], name: "index_payments_on_payee_id"
    t.index ["payer_id"], name: "index_payments_on_payer_id"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "signups", id: :serial, force: :cascade do |t|
    t.string "subject"
    t.boolean "student"
    t.integer "user_id"
    t.string "comments"
    t.index ["user_id"], name: "index_signups_on_user_id"
  end

  create_table "subjects", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "suggestions", id: :serial, force: :cascade do |t|
    t.integer "engagement_id"
    t.integer "suggested_minutes"
    t.text "description"
    t.text "status", default: "pending"
    t.index ["engagement_id"], name: "index_suggestions_on_engagement_id"
  end

  create_table "timesheets", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "minutes"
    t.text "description"
    t.date "date"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_timesheets_on_user_id"
  end

  create_table "tutor_profiles", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "subject_id"
    t.index ["subject_id"], name: "index_tutor_profiles_on_subject_id"
    t.index ["user_id"], name: "index_tutor_profiles_on_user_id"
  end

  create_table "user_roles", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "email"
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.string "phone_number"
    t.string "customer_id"
    t.string "auth_provider"
    t.string "auth_uid"
    t.string "encrypted_access_token"
    t.string "encrypted_access_token_iv"
    t.string "encrypted_refresh_token"
    t.string "encrypted_refresh_token_iv"
    t.integer "token_expires_at"
    t.string "access_state", default: "disabled", null: false
    t.integer "client_id"
    t.decimal "academic_credit", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "test_prep_credit", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "outstanding_balance", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "academic_rate_cents", default: 2999, null: false
    t.string "academic_rate_currency", default: "USD", null: false
    t.integer "test_prep_rate_cents", default: 5999, null: false
    t.string "test_prep_rate_currency", default: "USD", null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

  add_foreign_key "availabilities", "engagements"
  add_foreign_key "contracts", "users"
  add_foreign_key "feedbacks", "users"
  add_foreign_key "payments", "users", column: "payee_id"
  add_foreign_key "payments", "users", column: "payer_id"
  add_foreign_key "signups", "users"
end
