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

ActiveRecord::Schema.define(version: 20160423113727) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: :cascade do |t|
    t.integer  "company_id",             null: false
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "brands", ["company_id", "name"], name: "index_brands_on_company_id_and_name", unique: true, using: :btree

  create_table "cities", force: :cascade do |t|
    t.string   "name",       limit: 32, null: false
    t.datetime "created_at"
  end

  add_index "cities", ["name"], name: "index_cities_on_name", using: :btree

  create_table "companies", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "assignee_id"
    t.integer  "status",      default: 0,  null: false
    t.string   "type",        default: "", null: false
    t.string   "name"
    t.string   "email"
    t.string   "vat_number"
    t.string   "phone"
    t.string   "fax"
    t.string   "website"
    t.text     "description"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "companies", ["company_id"], name: "index_companies_on_company_id", using: :btree
  add_index "companies", ["type"], name: "index_companies_on_type", using: :btree

  create_table "item_types", force: :cascade do |t|
    t.integer  "company_id",             null: false
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "items", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "supplier_id"
    t.integer  "item_type_id"
    t.integer  "brand_id"
    t.integer  "status",                   default: 0,  null: false
    t.string   "name",         limit: 255, default: "", null: false
    t.text     "description"
    t.datetime "deleted_at"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "items", ["company_id"], name: "index_items_on_company_id", using: :btree
  add_index "items", ["name"], name: "index_items_on_name", using: :btree

  create_table "location_variants", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "location_id"
    t.integer  "variant_id"
    t.integer  "quantity"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "location_variants", ["company_id"], name: "index_location_variants_on_company_id", using: :btree
  add_index "location_variants", ["location_id"], name: "index_location_variants_on_location_id", using: :btree
  add_index "location_variants", ["variant_id"], name: "index_location_variants_on_variant_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.integer  "locationable_id"
    t.string   "locationable_type"
    t.integer  "city_id"
    t.string   "zip",               limit: 8
    t.string   "address",           limit: 255
    t.string   "name",              limit: 255
    t.boolean  "holds_stock",                   default: true
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  add_index "locations", ["locationable_type", "locationable_id"], name: "index_locations_on_locationable_type_and_locationable_id", using: :btree

  create_table "purchase_order_details", force: :cascade do |t|
    t.integer  "purchase_order_id"
    t.integer  "variant_id"
    t.integer  "quantity"
    t.integer  "cost_per_unit"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "purchase_order_details", ["purchase_order_id"], name: "index_purchase_order_details_on_purchase_order_id", using: :btree
  add_index "purchase_order_details", ["variant_id"], name: "index_purchase_order_details_on_variant_id", using: :btree

  create_table "purchase_orders", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "supplier_id"
    t.integer  "bill_to_location_id"
    t.integer  "ship_to_location_id"
    t.string   "status"
    t.integer  "total_amount"
    t.date     "due_on"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "order_number",        limit: 64
    t.string   "contact_email",       limit: 64
    t.text     "notes"
  end

  add_index "purchase_orders", ["company_id", "supplier_id"], name: "index_purchase_orders_on_company_id_and_supplier_id", using: :btree
  add_index "purchase_orders", ["status"], name: "index_purchase_orders_on_status", using: :btree

  create_table "stock_transfer_details", force: :cascade do |t|
    t.integer  "stock_transfer_id"
    t.integer  "variant_id"
    t.integer  "quantity"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "stock_transfer_details", ["stock_transfer_id"], name: "index_stock_transfer_details_on_stock_transfer_id", using: :btree

  create_table "stock_transfers", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "source_location_id"
    t.integer  "destination_location_id"
    t.string   "status",                  limit: 32, null: false
    t.string   "order_number",            limit: 64
    t.date     "expected_transfer_date"
    t.datetime "transferred_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "stock_transfers", ["company_id"], name: "index_stock_transfers_on_company_id", using: :btree
  add_index "stock_transfers", ["status"], name: "index_stock_transfers_on_status", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.integer  "company_id"
    t.string   "name",                   default: "", null: false
    t.string   "phone_number"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["company_id"], name: "index_users_on_company_id", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "variants", force: :cascade do |t|
    t.integer  "item_id",                                             null: false
    t.string   "sku"
    t.string   "name"
    t.integer  "buy_price"
    t.integer  "cost_per_unit"
    t.integer  "retail_price"
    t.integer  "wholesale_price"
    t.integer  "available_count",                         default: 0, null: false
    t.integer  "on_hand_count",                           default: 0, null: false
    t.decimal  "weight_value",    precision: 8, scale: 2
    t.integer  "weight_unit_id"
    t.text     "description"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  add_index "variants", ["item_id"], name: "index_variants_on_item_id", using: :btree
  add_index "variants", ["name"], name: "index_variants_on_name", using: :btree
  add_index "variants", ["sku"], name: "index_variants_on_sku", using: :btree

  create_table "weight_units", force: :cascade do |t|
    t.integer  "company_id",            null: false
    t.string   "name",       limit: 32, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "weight_units", ["company_id", "name"], name: "index_weight_units_on_company_id_and_name", unique: true, using: :btree

end
