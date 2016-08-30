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

ActiveRecord::Schema.define(version: 20160815104724) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bin_locations", force: :cascade do |t|
    t.integer  "location_id", null: false
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "bin_locations", ["location_id"], name: "index_bin_locations_on_location_id", using: :btree

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

  create_table "item_series", force: :cascade do |t|
    t.integer  "company_id",                           null: false
    t.integer  "brand_id"
    t.integer  "manufacturer_id"
    t.integer  "storage_and_transport_condition"
    t.integer  "expiration_alert_days"
    t.string   "name"
    t.string   "storage_and_transport_condition_note"
    t.text     "raw_material"
    t.text     "main_and_auxiliary_material"
    t.text     "food_additives"
    t.text     "warnings"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "item_series", ["company_id"], name: "index_item_series_on_company_id", using: :btree
  add_index "item_series", ["name"], name: "index_item_series_on_name", using: :btree

  create_table "items", force: :cascade do |t|
    t.integer  "company_id",                                                               null: false
    t.integer  "item_series_id"
    t.integer  "packaging_type_id"
    t.integer  "available_count",                                          default: 0,     null: false
    t.integer  "on_hand_count",                                            default: 0,     null: false
    t.integer  "cost_per_unit"
    t.integer  "purchase_price"
    t.integer  "wholesale_price"
    t.integer  "retail_price"
    t.integer  "low_stock_alert_level"
    t.integer  "status",                limit: 2,                          default: 0,     null: false
    t.integer  "weight_unit",           limit: 2
    t.decimal  "weight_value",                    precision: 10, scale: 2
    t.boolean  "manufactured_by_self",                                     default: false, null: false
    t.boolean  "expirable",                                                default: true,  null: false
    t.string   "image"
    t.string   "sku"
    t.string   "name",                                                     default: "",    null: false
    t.text     "description"
    t.datetime "created_at",                                                               null: false
    t.datetime "updated_at",                                                               null: false
  end

  add_index "items", ["company_id"], name: "index_items_on_company_id", using: :btree
  add_index "items", ["name"], name: "index_items_on_name", using: :btree

  create_table "location_variants", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "bin_location_id"
    t.integer  "variant_id"
    t.integer  "quantity",        default: 0, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "location_variants", ["bin_location_id"], name: "index_location_variants_on_bin_location_id", using: :btree
  add_index "location_variants", ["company_id"], name: "index_location_variants_on_company_id", using: :btree
  add_index "location_variants", ["variant_id"], name: "index_location_variants_on_variant_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.integer  "locationable_id"
    t.string   "locationable_type"
    t.integer  "city_id"
    t.string   "zip",               limit: 8
    t.string   "phone",             limit: 32
    t.string   "email",             limit: 64
    t.string   "address",           limit: 255
    t.string   "name",              limit: 255
    t.boolean  "holds_stock",                   default: false, null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "locations", ["locationable_type", "locationable_id"], name: "index_locations_on_locationable_type_and_locationable_id", using: :btree

  create_table "manufacturers", force: :cascade do |t|
    t.integer "company_id"
    t.integer "location_type",       limit: 2
    t.string  "name"
    t.string  "registration_number"
    t.string  "address"
  end

  add_index "manufacturers", ["company_id"], name: "index_manufacturers_on_company_id", using: :btree

  create_table "packaging_types", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "packaging_types", ["company_id"], name: "index_packaging_types_on_company_id", using: :btree

  create_table "partner_relationships", force: :cascade do |t|
    t.integer  "partner_id",      null: false
    t.integer  "partner_role_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "partner_relationships", ["partner_id", "partner_role_id"], name: "index_partner_relationships_on_partner_id_and_partner_role_id", unique: true, using: :btree

  create_table "partner_roles", force: :cascade do |t|
    t.string   "name",         null: false
    t.string   "chinese_name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "partners", force: :cascade do |t|
    t.integer  "company_id",                                              null: false
    t.integer  "partner_type",                                            null: false
    t.integer  "status",                                                  null: false
    t.integer  "receipt_type",                                            null: false
    t.string   "name",                                        limit: 128, null: false
    t.string   "alias_name",                                  limit: 128
    t.string   "email",                                       limit: 64
    t.string   "tax_number",                                  limit: 32
    t.string   "phone",                                       limit: 32
    t.string   "fax",                                         limit: 32
    t.string   "food_industry_registration_number",           limit: 64
    t.string   "factory_registration_number",                 limit: 64
    t.string   "no_food_industry_registration_number_reason", limit: 255
    t.string   "website",                                     limit: 255
    t.text     "description"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
  end

  add_index "partners", ["alias_name"], name: "index_partners_on_alias_name", using: :btree
  add_index "partners", ["company_id"], name: "index_partners_on_company_id", using: :btree
  add_index "partners", ["name"], name: "index_partners_on_name", using: :btree

  create_table "purchase_order_details", force: :cascade do |t|
    t.integer  "purchase_order_id"
    t.integer  "item_id"
    t.integer  "quantity"
    t.integer  "unit_price"
    t.date     "manufacturing_date"
    t.date     "expiry_date"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "purchase_order_details", ["item_id"], name: "index_purchase_order_details_on_item_id", using: :btree
  add_index "purchase_order_details", ["purchase_order_id"], name: "index_purchase_order_details_on_purchase_order_id", using: :btree

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

  create_table "sales_order_details", force: :cascade do |t|
    t.integer  "sales_order_id"
    t.integer  "variant_id"
    t.integer  "quantity"
    t.integer  "unit_price"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.text     "notes"
  end

  add_index "sales_order_details", ["sales_order_id"], name: "index_sales_order_details_on_sales_order_id", using: :btree
  add_index "sales_order_details", ["variant_id"], name: "index_sales_order_details_on_variant_id", using: :btree

  create_table "sales_orders", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "customer_id"
    t.integer  "bill_to_location_id"
    t.integer  "ship_to_location_id"
    t.integer  "ship_from_location_id"
    t.integer  "assignee_id"
    t.string   "status"
    t.integer  "total_amount"
    t.date     "issued_on"
    t.date     "shipped_on"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "order_number",          limit: 64
    t.string   "contact_email",         limit: 64
    t.text     "notes"
  end

  add_index "sales_orders", ["company_id", "customer_id"], name: "index_sales_orders_on_company_id_and_customer_id", using: :btree
  add_index "sales_orders", ["status"], name: "index_sales_orders_on_status", using: :btree

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
    t.string   "password_digest",        default: "", null: false
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["company_id"], name: "index_users_on_company_id", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "variants", force: :cascade do |t|
    t.integer  "item_id",                                               null: false
    t.integer  "quantity",                                  default: 0, null: false
    t.date     "manufacturing_date"
    t.date     "expiry_date"
    t.string   "import_admitted_notice_number", limit: 255
    t.string   "goods_declaration_number",      limit: 255
    t.string   "item_number",                   limit: 255
    t.string   "lot_number",                    limit: 255
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
  end

  add_index "variants", ["expiry_date"], name: "index_variants_on_expiry_date", using: :btree
  add_index "variants", ["goods_declaration_number"], name: "index_variants_on_goods_declaration_number", using: :btree
  add_index "variants", ["import_admitted_notice_number"], name: "index_variants_on_import_admitted_notice_number", using: :btree
  add_index "variants", ["item_id"], name: "index_variants_on_item_id", using: :btree

  add_foreign_key "bin_locations", "locations"
  add_foreign_key "brands", "companies"
  add_foreign_key "item_series", "brands"
  add_foreign_key "item_series", "companies"
  add_foreign_key "item_series", "partners", column: "manufacturer_id"
  add_foreign_key "items", "companies"
  add_foreign_key "items", "item_series"
  add_foreign_key "items", "packaging_types"
  add_foreign_key "location_variants", "bin_locations"
  add_foreign_key "location_variants", "companies"
  add_foreign_key "location_variants", "variants"
  add_foreign_key "locations", "cities"
  add_foreign_key "manufacturers", "companies"
  add_foreign_key "packaging_types", "companies"
  add_foreign_key "partner_relationships", "partner_roles"
  add_foreign_key "partner_relationships", "partners"
  add_foreign_key "partners", "companies"
  add_foreign_key "purchase_order_details", "items"
  add_foreign_key "purchase_order_details", "purchase_orders"
  add_foreign_key "purchase_orders", "companies"
  add_foreign_key "purchase_orders", "companies", column: "supplier_id"
  add_foreign_key "purchase_orders", "locations", column: "bill_to_location_id"
  add_foreign_key "purchase_orders", "locations", column: "ship_to_location_id"
  add_foreign_key "sales_order_details", "sales_orders"
  add_foreign_key "sales_order_details", "variants"
  add_foreign_key "sales_orders", "companies"
  add_foreign_key "sales_orders", "companies", column: "customer_id"
  add_foreign_key "sales_orders", "locations", column: "bill_to_location_id"
  add_foreign_key "sales_orders", "locations", column: "ship_from_location_id"
  add_foreign_key "sales_orders", "locations", column: "ship_to_location_id"
  add_foreign_key "stock_transfer_details", "stock_transfers"
  add_foreign_key "stock_transfer_details", "variants"
  add_foreign_key "stock_transfers", "companies"
  add_foreign_key "stock_transfers", "locations", column: "destination_location_id"
  add_foreign_key "stock_transfers", "locations", column: "source_location_id"
  add_foreign_key "variants", "items"
end
