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

ActiveRecord::Schema.define(version: 20150805191220) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "accounts", force: :cascade do |t|
    t.string   "email",              default: "", null: false
    t.string   "encrypted_password", default: "", null: false
    t.integer  "sign_in_count",      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "role",               default: 0
    t.string   "fname",              default: ""
    t.string   "lname",              default: ""
    t.integer  "meta_id"
    t.string   "meta_type"
  end

  add_index "accounts", ["email"], name: "index_accounts_on_email", unique: true, using: :btree
  add_index "accounts", ["meta_id", "meta_type"], name: "index_accounts_on_meta_id_and_meta_type", using: :btree

  create_table "autos", force: :cascade do |t|
    t.decimal  "total",      default: 0.0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "policy_id"
  end

  add_index "autos", ["policy_id"], name: "index_autos_on_policy_id", using: :btree

  create_table "broker_accts", force: :cascade do |t|
    t.string   "name",         default: ""
    t.string   "code",         default: ""
    t.string   "contact_name", default: ""
    t.string   "email",        default: ""
    t.string   "phone",        default: ""
    t.string   "street",       default: ""
    t.string   "city",         default: ""
    t.string   "state",        default: ""
    t.string   "zip",          default: ""
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "broker_accts", ["code"], name: "index_broker_accts_on_code", unique: true, using: :btree

  create_table "brokers", force: :cascade do |t|
    t.string   "name",         default: ""
    t.string   "code",         default: ""
    t.string   "contact_name", default: ""
    t.string   "email",        default: ""
    t.string   "phone",        default: ""
    t.string   "street",       default: ""
    t.string   "city",         default: ""
    t.string   "state",        default: ""
    t.string   "zip",          default: ""
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "brokers", ["code"], name: "index_brokers_on_code", unique: true, using: :btree

  create_table "buildings", force: :cascade do |t|
    t.integer  "number",      default: 0
    t.string   "class_type",  default: ""
    t.string   "code",        default: ""
    t.decimal  "basis",       default: 0.0
    t.string   "basis_type",  default: ""
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "location_id"
  end

  add_index "buildings", ["location_id"], name: "index_buildings_on_location_id", using: :btree

  create_table "crimes", force: :cascade do |t|
    t.decimal  "total",                   default: 0.0
    t.decimal  "ded",                     default: 0.0
    t.decimal  "limit_theft",             default: 0.0
    t.decimal  "limit_forgery",           default: 0.0
    t.decimal  "limit_money",             default: 0.0
    t.decimal  "limit_outside_robbery",   default: 0.0
    t.decimal  "limit_safe_burglary",     default: 0.0
    t.decimal  "limit_premises_burglary", default: 0.0
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "policy_id"
  end

  add_index "crimes", ["policy_id"], name: "index_crimes_on_policy_id", using: :btree

  create_table "employee_accts", force: :cascade do |t|
    t.integer  "role",       default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "gls", force: :cascade do |t|
    t.decimal  "total",           default: 0.0
    t.decimal  "limit_genagg",    default: 0.0
    t.decimal  "limit_products",  default: 0.0
    t.decimal  "limit_occurence", default: 0.0
    t.decimal  "limit_injury",    default: 0.0
    t.decimal  "limit_fire",      default: 0.0
    t.decimal  "limit_medical",   default: 0.0
    t.string   "water_gas_tank",  default: ""
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "policy_id"
  end

  add_index "gls", ["policy_id"], name: "index_gls_on_policy_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.integer  "number",         default: 0
    t.string   "street",         default: ""
    t.string   "city",           default: ""
    t.string   "state",          default: ""
    t.string   "zip",            default: ""
    t.decimal  "total",          default: 0.0
    t.string   "loss_coverage",  default: ""
    t.string   "enhancement",    default: ""
    t.string   "mechanical",     default: ""
    t.string   "theft",          default: ""
    t.string   "spoilage",       default: ""
    t.decimal  "coins",          default: 0.0
    t.string   "valuation",      default: ""
    t.decimal  "ded",            default: 0.0
    t.decimal  "limt_bldg",      default: 0.0
    t.decimal  "limit_bpp",      default: 0.0
    t.decimal  "limit_earnings", default: 0.0
    t.decimal  "limit_sign",     default: 0.0
    t.decimal  "limit_pumps",    default: 0.0
    t.decimal  "limit_canopies", default: 0.0
    t.string   "indemnity",      default: ""
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "policy_id"
  end

  add_index "locations", ["policy_id"], name: "index_locations_on_policy_id", using: :btree

  create_table "notifs", force: :cascade do |t|
    t.integer  "policy_id"
    t.integer  "user_id"
    t.string   "message",      default: "f"
    t.string   "message_type", default: ""
    t.boolean  "seen",         default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "policies", force: :cascade do |t|
    t.string   "number",         default: ""
    t.string   "status",         default: "EMPTY"
    t.string   "code",           default: ""
    t.string   "name",           default: ""
    t.date     "effective",      default: '1995-11-08'
    t.string   "forms",          default: ""
    t.string   "property_forms", default: ""
    t.string   "gl_forms",       default: ""
    t.string   "crime_forms",    default: ""
    t.string   "auto_forms",     default: ""
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "broker_id"
    t.date     "expiry",         default: '1995-11-08'
    t.string   "org",            default: ""
    t.string   "dba",            default: ""
    t.string   "biztype",        default: ""
    t.string   "street",         default: ""
    t.string   "city",           default: ""
    t.string   "state",          default: ""
    t.string   "zip",            default: ""
    t.decimal  "total_premium",  default: 0.0
    t.text     "comment",        default: ""
    t.string   "policy_pdf"
  end

  add_index "policies", ["broker_id"], name: "index_policies_on_broker_id", using: :btree
  add_index "policies", ["number"], name: "index_policies_on_number", unique: true, using: :btree

  create_table "properties", force: :cascade do |t|
    t.decimal  "total",      default: 0.0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "policy_id"
  end

  add_index "properties", ["policy_id"], name: "index_properties_on_policy_id", using: :btree

  create_table "quotes", force: :cascade do |t|
    t.integer  "broker_fee"
    t.decimal  "broker_commission"
    t.date     "effective"
    t.date     "retro"
    t.boolean  "addl_employment"
    t.boolean  "addl_electronic"
    t.boolean  "addl_medefense"
    t.boolean  "addl_sexual"
    t.text     "addl_shared",          default: [],              array: true
    t.text     "addl_separate",        default: [],              array: true
    t.text     "excl_locations",       default: [],              array: true
    t.text     "excl_procedures",      default: [],              array: true
    t.text     "subjectivities",       default: [],              array: true
    t.text     "policy_forms",         default: [],              array: true
    t.string   "policy_type"
    t.integer  "deductible"
    t.string   "limit"
    t.integer  "fairway_premium"
    t.integer  "capital_contribution"
    t.string   "payment_type"
    t.integer  "status",               default: 0
    t.datetime "issue_date"
    t.datetime "status_date"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "rating_id"
    t.string   "quote_pdf"
  end

  add_index "quotes", ["addl_separate"], name: "index_quotes_on_addl_separate", using: :gin
  add_index "quotes", ["addl_shared"], name: "index_quotes_on_addl_shared", using: :gin
  add_index "quotes", ["excl_locations"], name: "index_quotes_on_excl_locations", using: :gin
  add_index "quotes", ["excl_procedures"], name: "index_quotes_on_excl_procedures", using: :gin
  add_index "quotes", ["policy_forms"], name: "index_quotes_on_policy_forms", using: :gin
  add_index "quotes", ["rating_id"], name: "index_quotes_on_rating_id", using: :btree
  add_index "quotes", ["subjectivities"], name: "index_quotes_on_subjectivities", using: :gin

  create_table "ratings", force: :cascade do |t|
    t.hstore   "risk_prof"
    t.hstore   "rates"
    t.hstore   "factors"
    t.hstore   "risk_factors"
    t.integer  "policy_year"
    t.boolean  "capital"
    t.decimal  "physician_premium",    default: 0.0
    t.decimal  "allied_premium",       default: 0.0
    t.decimal  "nas_premium",          default: 0.0
    t.decimal  "fairway_premium",      default: 0.0
    t.decimal  "total_premium",        default: 0.0
    t.integer  "capital_contribution", default: 0
    t.integer  "status",               default: 0
    t.datetime "status_date"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "risk_profile_id"
  end

  add_index "ratings", ["risk_profile_id"], name: "index_ratings_on_risk_profile_id", using: :btree

  create_table "risk_factors", force: :cascade do |t|
    t.string   "criteria"
    t.decimal  "min_factor"
    t.decimal  "max_factor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "risk_profiles", force: :cascade do |t|
    t.string   "name"
    t.string   "state"
    t.string   "territory"
    t.date     "effective"
    t.date     "retro"
    t.string   "specialty"
    t.string   "specialty_surgery"
    t.integer  "deductible"
    t.string   "limit"
    t.string   "limit_nas"
    t.string   "addl_shared"
    t.string   "addl_separate"
    t.boolean  "entity"
    t.integer  "allied1"
    t.integer  "allied2"
    t.integer  "allied3"
    t.string   "sub_specialty"
    t.boolean  "capital"
    t.string   "license"
    t.integer  "status",            default: 0
    t.datetime "status_date"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "broker_acct_id"
  end

  add_index "risk_profiles", ["broker_acct_id"], name: "index_risk_profiles_on_broker_acct_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "fname",                  default: ""
    t.string   "lname",                  default: ""
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "autos", "policies"
  add_foreign_key "buildings", "locations"
  add_foreign_key "crimes", "policies"
  add_foreign_key "gls", "policies"
  add_foreign_key "locations", "policies"
  add_foreign_key "policies", "brokers"
  add_foreign_key "properties", "policies"
  add_foreign_key "quotes", "ratings"
  add_foreign_key "ratings", "risk_profiles"
  add_foreign_key "risk_profiles", "broker_accts"
end
