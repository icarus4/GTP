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

ActiveRecord::Schema.define(version: 20170203063942) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blazer_audits", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "query_id"
    t.text     "statement"
    t.string   "data_source"
    t.datetime "created_at"
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.integer  "creator_id"
    t.integer  "query_id"
    t.string   "state"
    t.string   "schedule"
    t.text     "emails"
    t.string   "check_type"
    t.text     "message"
    t.datetime "last_run_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.integer  "dashboard_id"
    t.integer  "query_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.integer  "creator_id"
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.integer  "creator_id"
    t.string   "name"
    t.text     "description"
    t.text     "statement"
    t.string   "data_source"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "brands", force: :cascade do |t|
    t.integer  "company_id",             null: false
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["company_id", "name"], name: "index_brands_on_company_id_and_name", unique: true, using: :btree
  end

  create_table "cities", force: :cascade do |t|
    t.string   "name",       limit: 32, null: false
    t.datetime "created_at"
    t.index ["name"], name: "index_cities_on_name", using: :btree
  end

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
    t.jsonb    "settings",    default: {}, null: false
    t.text     "description"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["company_id"], name: "index_companies_on_company_id", using: :btree
    t.index ["type"], name: "index_companies_on_type", using: :btree
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "contactable_type"
    t.integer  "contactable_id"
    t.string   "name",             null: false
    t.string   "title"
    t.string   "phone"
    t.string   "mobile"
    t.string   "fax"
    t.string   "email"
    t.string   "department"
    t.text     "notes"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["contactable_type", "contactable_id"], name: "index_contacts_on_contactable_type_and_contactable_id", using: :btree
  end

  create_table "item_packs", force: :cascade do |t|
    t.integer  "item_id"
    t.string   "name",       null: false
    t.integer  "size",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_item_packs_on_item_id", using: :btree
  end

  create_table "item_price_lists", force: :cascade do |t|
    t.integer  "item_id",                                null: false
    t.integer  "price_list_id",                          null: false
    t.decimal  "price",         precision: 12, scale: 2, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.index ["item_id", "price_list_id"], name: "index_item_price_lists_on_item_id_and_price_list_id", unique: true, using: :btree
    t.index ["item_id"], name: "index_item_price_lists_on_item_id", using: :btree
    t.index ["price_list_id"], name: "index_item_price_lists_on_price_list_id", using: :btree
  end

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
    t.index ["company_id"], name: "index_item_series_on_company_id", using: :btree
    t.index ["name"], name: "index_item_series_on_name", using: :btree
  end

  create_table "items", force: :cascade do |t|
    t.integer  "company_id",                                                               null: false
    t.integer  "item_series_id"
    t.integer  "packaging_type_id"
    t.integer  "available_count",                                          default: 0,     null: false
    t.integer  "on_hand_count",                                            default: 0,     null: false
    t.decimal  "cost_per_unit",                   precision: 10, scale: 2
    t.decimal  "purchase_price",                  precision: 10, scale: 2
    t.decimal  "wholesale_price",                 precision: 10, scale: 2
    t.decimal  "retail_price",                    precision: 10, scale: 2
    t.integer  "low_stock_alert_level"
    t.integer  "status",                limit: 2,                          default: 0,     null: false
    t.integer  "weight_unit",           limit: 2
    t.decimal  "weight_value",                    precision: 10, scale: 2
    t.boolean  "manufactured_by_self",                                     default: false, null: false
    t.boolean  "expirable",                                                default: true,  null: false
    t.boolean  "sellable",                                                 default: true,  null: false
    t.boolean  "purchasable",                                              default: true,  null: false
    t.string   "image"
    t.string   "sku"
    t.string   "sku_from_supplier"
    t.string   "name",                                                     default: "",    null: false
    t.text     "description"
    t.datetime "created_at",                                                               null: false
    t.datetime "updated_at",                                                               null: false
    t.integer  "quantity",                                                 default: 0,     null: false
    t.integer  "committed_quantity",                                       default: 0,     null: false
    t.integer  "sellable_quantity",                                        default: 0,     null: false
    t.index ["company_id"], name: "index_items_on_company_id", using: :btree
    t.index ["item_series_id"], name: "index_items_on_item_series_id", using: :btree
    t.index ["name"], name: "index_items_on_name", using: :btree
    t.index ["sku"], name: "index_items_on_sku", using: :btree
  end

  create_table "location_variants", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "variant_id"
    t.integer  "quantity",           default: 0, null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "location_id"
    t.integer  "item_id"
    t.date     "expiry_date"
    t.integer  "committed_quantity", default: 0, null: false
    t.integer  "sellable_quantity",  default: 0, null: false
    t.index ["company_id"], name: "index_location_variants_on_company_id", using: :btree
    t.index ["quantity"], name: "index_location_variants_on_quantity", where: "(quantity > 0)", using: :btree
    t.index ["variant_id"], name: "index_location_variants_on_variant_id", using: :btree
  end

  create_table "locations", force: :cascade do |t|
    t.string   "locationable_type"
    t.integer  "locationable_id"
    t.integer  "city_id"
    t.string   "zip",               limit: 8
    t.string   "phone",             limit: 32
    t.string   "email",             limit: 64
    t.string   "address",           limit: 255
    t.string   "name",              limit: 255
    t.boolean  "holds_stock",                   default: false, null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.index ["locationable_type", "locationable_id"], name: "index_locations_on_locationable_type_and_locationable_id", using: :btree
  end

  create_table "packaging_types", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_packaging_types_on_company_id", using: :btree
  end

  create_table "partner_relationships", force: :cascade do |t|
    t.integer  "partner_id",      null: false
    t.integer  "partner_role_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["partner_id", "partner_role_id"], name: "index_partner_relationships_on_partner_id_and_partner_role_id", unique: true, using: :btree
  end

  create_table "partner_roles", force: :cascade do |t|
    t.string   "name",         null: false
    t.string   "chinese_name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "partners", force: :cascade do |t|
    t.integer  "company_id",                                                           null: false
    t.integer  "partner_type",                                                         null: false
    t.integer  "status",                                                               null: false
    t.integer  "receipt_type",                                                         null: false
    t.string   "name",                                        limit: 128,              null: false
    t.string   "alias_name",                                  limit: 128
    t.string   "email",                                       limit: 64
    t.string   "tax_number",                                  limit: 32
    t.string   "phone",                                       limit: 32
    t.string   "fax",                                         limit: 32
    t.string   "food_industry_registration_number",           limit: 64
    t.string   "factory_registration_number",                 limit: 64
    t.string   "no_food_industry_registration_number_reason", limit: 255
    t.string   "website",                                     limit: 255
    t.jsonb    "settings",                                                default: {}, null: false
    t.text     "description"
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
    t.index ["alias_name"], name: "index_partners_on_alias_name", using: :btree
    t.index ["company_id"], name: "index_partners_on_company_id", using: :btree
    t.index ["name"], name: "index_partners_on_name", using: :btree
  end

  create_table "payment_methods", force: :cascade do |t|
    t.integer  "company_id", null: false
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_payment_methods_on_company_id", using: :btree
  end

  create_table "payment_terms", force: :cascade do |t|
    t.integer  "company_id",  null: false
    t.string   "name",        null: false
    t.integer  "due_in_days", null: false
    t.integer  "start_from",  null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["company_id"], name: "index_payment_terms_on_company_id", using: :btree
  end

  create_table "price_lists", force: :cascade do |t|
    t.integer  "company_id",      null: false
    t.string   "name",            null: false
    t.integer  "price_list_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["company_id"], name: "index_price_lists_on_company_id", using: :btree
  end

  create_table "procurements", force: :cascade do |t|
    t.integer  "purchase_order_id", null: false
    t.datetime "procured_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["purchase_order_id"], name: "index_procurements_on_purchase_order_id", using: :btree
  end

  create_table "purchase_order_details", force: :cascade do |t|
    t.integer  "purchase_order_id"
    t.integer  "item_id"
    t.integer  "quantity"
    t.integer  "unit_price"
    t.date     "manufacturing_date"
    t.date     "expiry_date"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["item_id"], name: "index_purchase_order_details_on_item_id", using: :btree
    t.index ["purchase_order_id"], name: "index_purchase_order_details_on_purchase_order_id", using: :btree
  end

  create_table "purchase_order_line_items", force: :cascade do |t|
    t.integer  "purchase_order_id",                                        null: false
    t.integer  "procurement_id"
    t.integer  "item_id",                                                  null: false
    t.integer  "variant_id"
    t.integer  "location_id"
    t.integer  "location_variant_id"
    t.integer  "quantity",                                                 null: false
    t.decimal  "unit_price",          precision: 10, scale: 2,             null: false
    t.decimal  "tax_rate",            precision: 4,  scale: 1
    t.decimal  "tax",                 precision: 10, scale: 2
    t.decimal  "total",               precision: 12, scale: 2,             null: false
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.integer  "returned_quantity",                            default: 0, null: false
    t.index ["item_id"], name: "index_purchase_order_line_items_on_item_id", using: :btree
    t.index ["location_id"], name: "index_purchase_order_line_items_on_location_id", using: :btree
    t.index ["location_variant_id"], name: "index_purchase_order_line_items_on_location_variant_id", using: :btree
    t.index ["procurement_id"], name: "index_purchase_order_line_items_on_procurement_id", using: :btree
    t.index ["purchase_order_id"], name: "index_purchase_order_line_items_on_purchase_order_id", using: :btree
    t.index ["variant_id"], name: "index_purchase_order_line_items_on_variant_id", using: :btree
  end

  create_table "purchase_order_return_line_items", force: :cascade do |t|
    t.integer  "purchase_order_return_id", null: false
    t.integer  "line_item_id",             null: false
    t.integer  "item_id",                  null: false
    t.integer  "quantity",                 null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["item_id"], name: "index_purchase_order_return_line_items_on_item_id", using: :btree
    t.index ["line_item_id"], name: "index_purchase_order_return_line_items_on_line_item_id", using: :btree
    t.index ["purchase_order_return_id"], name: "index_por_line_items_on_purchase_order_return_id", using: :btree
  end

  create_table "purchase_order_returns", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "purchase_order_id"
    t.string   "order_number"
    t.text     "notes"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["company_id"], name: "index_purchase_order_returns_on_company_id", using: :btree
    t.index ["order_number"], name: "index_purchase_order_returns_on_order_number", using: :btree
    t.index ["purchase_order_id"], name: "index_purchase_order_returns_on_purchase_order_id", using: :btree
  end

  create_table "purchase_orders", force: :cascade do |t|
    t.integer  "company_id",                                                  null: false
    t.integer  "partner_id"
    t.integer  "currency_id"
    t.integer  "payment_method_id"
    t.integer  "assignee_id"
    t.integer  "bill_to_location_id"
    t.integer  "ship_from_location_id"
    t.integer  "ship_to_location_id"
    t.integer  "line_items_count",                                default: 0, null: false
    t.string   "order_number"
    t.integer  "status",                                          default: 0, null: false
    t.string   "email"
    t.integer  "return_status",                                   default: 0, null: false
    t.integer  "tax_treatment",                                   default: 0, null: false
    t.integer  "total_units"
    t.decimal  "subtotal",               precision: 12, scale: 2
    t.decimal  "total_tax",              precision: 12, scale: 2
    t.decimal  "total_amount",           precision: 12, scale: 2
    t.date     "paid_on"
    t.date     "expected_delivery_date"
    t.text     "notes"
    t.jsonb    "extra_info"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.index ["company_id", "partner_id"], name: "index_purchase_orders_on_company_id_and_partner_id", using: :btree
    t.index ["order_number"], name: "index_purchase_orders_on_order_number", using: :btree
  end

  create_table "sales_order_details", force: :cascade do |t|
    t.integer  "sales_order_id"
    t.integer  "variant_id"
    t.integer  "quantity"
    t.integer  "unit_price"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.text     "notes"
    t.index ["sales_order_id"], name: "index_sales_order_details_on_sales_order_id", using: :btree
    t.index ["variant_id"], name: "index_sales_order_details_on_variant_id", using: :btree
  end

  create_table "sales_order_line_item_commitments", force: :cascade do |t|
    t.integer  "line_item_id"
    t.integer  "location_id"
    t.integer  "location_variant_id"
    t.integer  "variant_id"
    t.integer  "item_id"
    t.integer  "shipment_id"
    t.integer  "quantity",            default: 0, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["item_id"], name: "index_sales_order_line_item_commitments_on_item_id", using: :btree
    t.index ["line_item_id"], name: "index_sales_order_line_item_commitments_on_line_item_id", using: :btree
    t.index ["location_id"], name: "index_sales_order_line_item_commitments_on_location_id", using: :btree
    t.index ["location_variant_id"], name: "index_line_item_commitments_on_location_variant_id", using: :btree
    t.index ["shipment_id"], name: "index_sales_order_line_item_commitments_on_shipment_id", using: :btree
    t.index ["variant_id"], name: "index_sales_order_line_item_commitments_on_variant_id", using: :btree
  end

  create_table "sales_order_line_items", force: :cascade do |t|
    t.integer  "sales_order_id",                                            null: false
    t.integer  "item_id",                                                   null: false
    t.integer  "quantity",                                                  null: false
    t.integer  "committed_quantity",                                        null: false
    t.integer  "uncommitted_quantity",                                      null: false
    t.decimal  "unit_price",           precision: 10, scale: 2,             null: false
    t.decimal  "tax_rate",             precision: 4,  scale: 1
    t.decimal  "tax",                  precision: 10, scale: 2
    t.decimal  "total",                precision: 12, scale: 2,             null: false
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.integer  "shipment_status",                               default: 0, null: false
    t.integer  "shipped_quantity",                              default: 0, null: false
    t.index ["item_id"], name: "index_sales_order_line_items_on_item_id", using: :btree
    t.index ["sales_order_id"], name: "index_sales_order_line_items_on_sales_order_id", using: :btree
  end

  create_table "sales_order_shipments", force: :cascade do |t|
    t.integer  "sales_order_id"
    t.datetime "shipped_at"
    t.date     "shipped_on"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["sales_order_id"], name: "index_sales_order_shipments_on_sales_order_id", using: :btree
  end

  create_table "sales_orders", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "partner_id"
    t.integer  "bill_to_location_id"
    t.integer  "ship_to_location_id"
    t.integer  "ship_from_location_id"
    t.integer  "assignee_id"
    t.integer  "payment_method_id"
    t.integer  "status",                                          default: 0, null: false
    t.integer  "invoice_status",                                  default: 0, null: false
    t.integer  "packing_status",                                  default: 0, null: false
    t.integer  "shipment_status",                                 default: 0, null: false
    t.integer  "payment_status",                                  default: 0, null: false
    t.integer  "tax_treatment",                                   default: 0, null: false
    t.integer  "line_items_count",                                default: 0, null: false
    t.integer  "total_units",                                     default: 0, null: false
    t.decimal  "subtotal",               precision: 12, scale: 2
    t.decimal  "total_tax",              precision: 12, scale: 2
    t.decimal  "total_amount",           precision: 12, scale: 2
    t.date     "issued_on"
    t.date     "expected_delivery_date"
    t.string   "order_number"
    t.string   "email"
    t.text     "notes"
    t.jsonb    "extra_info"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.string   "phone"
    t.index ["company_id", "partner_id"], name: "index_sales_orders_on_company_id_and_partner_id", using: :btree
    t.index ["order_number"], name: "index_sales_orders_on_order_number", using: :btree
  end

  create_table "stock_transfer_details", force: :cascade do |t|
    t.integer  "stock_transfer_id"
    t.integer  "variant_id"
    t.integer  "quantity"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["stock_transfer_id"], name: "index_stock_transfer_details_on_stock_transfer_id", using: :btree
  end

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
    t.index ["company_id"], name: "index_stock_transfers_on_company_id", using: :btree
    t.index ["status"], name: "index_stock_transfers_on_status", using: :btree
  end

  create_table "tax_types", force: :cascade do |t|
    t.integer  "company_id",                         null: false
    t.decimal  "percentage", precision: 4, scale: 1, null: false
    t.decimal  "rate",       precision: 4, scale: 3, null: false
    t.string   "name",                               null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["company_id"], name: "index_tax_types_on_company_id", using: :btree
  end

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
    t.index ["company_id"], name: "index_users_on_company_id", using: :btree
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["name"], name: "index_users_on_name", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "variants", force: :cascade do |t|
    t.integer  "item_id",                                               null: false
    t.integer  "procurement_id"
    t.integer  "quantity",                                  default: 0, null: false
    t.date     "manufacturing_date"
    t.date     "expiry_date"
    t.string   "import_admitted_notice_number", limit: 255
    t.string   "goods_declaration_number",      limit: 255
    t.string   "item_number",                   limit: 255
    t.string   "lot_number",                    limit: 255
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "committed_quantity",                        default: 0, null: false
    t.integer  "sellable_quantity",                         default: 0, null: false
    t.index ["expiry_date"], name: "index_variants_on_expiry_date", using: :btree
    t.index ["goods_declaration_number"], name: "index_variants_on_goods_declaration_number", using: :btree
    t.index ["import_admitted_notice_number"], name: "index_variants_on_import_admitted_notice_number", using: :btree
    t.index ["item_id"], name: "index_variants_on_item_id", using: :btree
    t.index ["procurement_id"], name: "index_variants_on_procurement_id", using: :btree
  end

end
