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

ActiveRecord::Schema.define(version: 20180115070830) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "availabilities", id: :serial, force: :cascade do |t|
    t.datetime "from"
    t.datetime "to"
    t.integer "engagement_id"
    t.index ["engagement_id"], name: "index_availabilities_on_engagement_id"
  end

  create_table "blog_posts", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.date "publish_date"
    t.boolean "published", default: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["published"], name: "index_blog_posts_on_published"
    t.index ["user_id"], name: "index_blog_posts_on_user_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.string "country"
    t.string "state"
    t.string "phone_number"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "country_id"
    t.index ["country_id"], name: "index_cities_on_country_id"
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "client_accounts", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_client_accounts_on_user_id"
  end

  create_table "contractor_accounts", force: :cascade do |t|
    t.bigint "user_id"
    t.index ["user_id"], name: "index_contractor_accounts_on_user_id"
  end

  create_table "contracts", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "hourly_rate_cents", default: 1500, null: false
    t.string "hourly_rate_currency", default: "USD", null: false
    t.string "account_type"
    t.bigint "account_id"
    t.index ["account_type", "account_id"], name: "index_contracts_on_account_type_and_account_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.string "state", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "preferred_start_date"
    t.bigint "subject_id"
    t.bigint "student_account_id"
    t.bigint "client_account_id"
    t.bigint "tutor_account_id"
    t.index ["client_account_id"], name: "index_engagements_on_client_account_id"
    t.index ["student_account_id"], name: "index_engagements_on_student_account_id"
    t.index ["subject_id"], name: "index_engagements_on_subject_id"
    t.index ["tutor_account_id"], name: "index_engagements_on_tutor_account_id"
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
    t.integer "submitter_id"
    t.integer "engagement_id"
    t.decimal "hours", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "hourly_rate_cents"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.string "subject"
    t.integer "client_id"
    t.integer "submitter_pay_cents"
    t.integer "amount_cents"
    t.integer "submitter_type", default: 0
    t.string "note"
    t.index ["client_id"], name: "index_invoices_on_client_id"
    t.index ["engagement_id"], name: "index_invoices_on_engagement_id"
    t.index ["submitter_id"], name: "index_invoices_on_submitter_id"
  end

  create_table "payments", id: :serial, force: :cascade do |t|
    t.integer "amount_cents"
    t.string "description"
    t.string "status"
    t.string "customer_id"
    t.integer "payer_id"
    t.datetime "created_at"
    t.string "card_brand"
    t.string "last_four"
    t.string "stripe_charge_id"
    t.integer "rate_cents"
    t.string "hours_type"
    t.string "card_holder_name"
    t.decimal "hours_purchased", precision: 10, scale: 2
    t.index ["payer_id"], name: "index_payments_on_payer_id"
  end

  create_table "payouts", force: :cascade do |t|
    t.string "description"
    t.string "destination"
    t.string "dwolla_transfer_url"
    t.string "status"
    t.string "funding_source"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.integer "approver_id"
    t.string "receiving_account_type"
    t.bigint "receiving_account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiving_account_id", "receiving_account_type"], name: "index_payouts_receiver_account_and_type"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "signups", id: :serial, force: :cascade do |t|
    t.boolean "student"
    t.integer "user_id"
    t.string "comments"
    t.bigint "subject_id"
    t.index ["subject_id"], name: "index_signups_on_subject_id"
    t.index ["user_id"], name: "index_signups_on_user_id"
  end

  create_table "student_accounts", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_account_id"
    t.index ["client_account_id"], name: "index_student_accounts_on_client_account_id"
    t.index ["user_id"], name: "index_student_accounts_on_user_id"
  end

  create_table "subjects", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "academic_type", default: "academic"
  end

  create_table "subjects_tutor_accounts", id: false, force: :cascade do |t|
    t.bigint "subject_id", null: false
    t.bigint "tutor_account_id", null: false
    t.index ["subject_id"], name: "index_subjects_tutor_accounts_on_subject_id"
    t.index ["tutor_account_id"], name: "index_subjects_tutor_accounts_on_tutor_account_id"
  end

  create_table "suggestions", id: :serial, force: :cascade do |t|
    t.integer "engagement_id"
    t.integer "suggested_minutes"
    t.text "description"
    t.text "status", default: "pending"
    t.index ["engagement_id"], name: "index_suggestions_on_engagement_id"
  end

  create_table "tutor_accounts", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tutor_accounts_on_user_id"
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
  add_foreign_key "blog_posts", "users"
  add_foreign_key "cities", "countries"
  add_foreign_key "client_accounts", "users"
  add_foreign_key "contractor_accounts", "users"
  add_foreign_key "engagements", "client_accounts"
  add_foreign_key "engagements", "student_accounts"
  add_foreign_key "engagements", "subjects"
  add_foreign_key "feedbacks", "users"
  add_foreign_key "invoices", "engagements"
  add_foreign_key "payments", "users", column: "payer_id"
  add_foreign_key "signups", "users"
  add_foreign_key "student_accounts", "client_accounts"
  add_foreign_key "student_accounts", "users"
  add_foreign_key "tutor_accounts", "users"
end
