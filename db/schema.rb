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

ActiveRecord::Schema.define(version: 2018_05_11_220646) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "address_type"
    t.string "street1"
    t.string "street2"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.text "notes"
    t.boolean "primary", default: false
    t.index ["owner_type", "owner_id"], name: "index_addresses_on_owner_type_and_owner_id"
  end

  create_table "charges", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "stripe_charge_id"
    t.bigint "amount"
    t.boolean "deposit", default: false
    t.index ["owner_type", "owner_id"], name: "index_charges_on_owner_type_and_owner_id"
  end

  create_table "drivers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "gender"
    t.string "address_1"
    t.string "address_2"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "country"
    t.string "home_phone_number"
    t.string "cell_phone_number"
    t.string "email"
    t.date "date_of_birth"
    t.string "license_number"
    t.string "license_state"
    t.string "license_country"
    t.date "license_expiration_date"
    t.boolean "do_not_rent"
    t.string "stripe_id"
    t.text "notes"
    t.string "name_first"
    t.string "name_middle"
    t.string "name_last"
  end

  create_table "insurance_policies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "driver_id"
    t.string "company_name"
    t.string "agent"
    t.string "policy_number"
    t.string "phone_number"
    t.date "effective_date"
    t.date "expiration_date"
    t.date "verify_date"
    t.string "verify_agent"
    t.string "verify_call_center"
    t.index ["driver_id"], name: "index_insurance_policies_on_driver_id"
    t.index ["user_id"], name: "index_insurance_policies_on_user_id"
  end

  create_table "line_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invoice_type"
    t.bigint "invoice_id"
    t.bigint "charge_id"
    t.string "item_type"
    t.json "details"
    t.date "date"
    t.integer "quantity"
    t.bigint "total"
    t.bigint "amount"
    t.bigint "discount"
    t.bigint "sub_total"
    t.bigint "taxable_amount"
    t.bigint "tax_collectable"
    t.bigint "state_taxable_amount"
    t.bigint "state_amount"
    t.bigint "county_taxable_amount"
    t.bigint "county_amount"
    t.bigint "city_taxable_amount"
    t.bigint "city_amount"
    t.bigint "district_taxable_amount"
    t.bigint "district_amount"
    t.text "description"
    t.index ["charge_id"], name: "index_line_items_on_charge_id"
    t.index ["invoice_type", "invoice_id"], name: "index_line_items_on_invoice_type_and_invoice_id"
  end

  create_table "locations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "slug"
    t.string "latitude"
    t.string "longitude"
    t.string "address_1"
    t.string "address_2"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "country"
    t.string "phone_number"
  end

  create_table "locations_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "location_id"
    t.index ["location_id"], name: "index_locations_users_on_location_id"
    t.index ["user_id"], name: "index_locations_users_on_user_id"
  end

  create_table "phone_numbers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "phone_type"
    t.string "number"
    t.string "extension"
    t.text "notes"
    t.boolean "primary", default: false
    t.index ["owner_type", "owner_id"], name: "index_phone_numbers_on_owner_type_and_owner_id"
  end

  create_table "rates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "location_id"
    t.bigint "amount"
    t.string "vehicle_type"
    t.index ["location_id"], name: "index_rates_on_location_id"
  end

  create_table "rentals", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "number"
    t.string "source"
    t.string "status"
    t.boolean "confirmed"
    t.bigint "driver_id"
    t.bigint "additional_driver_id"
    t.bigint "vehicle_id"
    t.bigint "tax_rate_id"
    t.text "notes"
    t.bigint "pickup_location_id"
    t.datetime "pickup"
    t.bigint "pickup_odometer"
    t.float "pickup_fuel"
    t.bigint "drop_off_location_id"
    t.datetime "drop_off"
    t.bigint "drop_off_odometer"
    t.float "drop_off_fuel"
    t.boolean "collision_damage_waiver"
    t.text "driver_financial_responsibility_signature"
    t.text "additional_driver_financial_responsibility_signature"
    t.text "driver_signature"
    t.text "additional_driver_signature"
    t.index ["additional_driver_id"], name: "index_rentals_on_additional_driver_id"
    t.index ["driver_id"], name: "index_rentals_on_driver_id"
    t.index ["drop_off_location_id"], name: "index_rentals_on_drop_off_location_id"
    t.index ["pickup_location_id"], name: "index_rentals_on_pickup_location_id"
    t.index ["tax_rate_id"], name: "index_rentals_on_tax_rate_id"
    t.index ["vehicle_id"], name: "index_rentals_on_vehicle_id"
  end

  create_table "tax_rates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "location_id"
    t.decimal "combined_tax_rate", precision: 14, scale: 4
    t.decimal "state_tax_rate", precision: 14, scale: 4
    t.decimal "county_tax_rate", precision: 14, scale: 4
    t.decimal "city_tax_rate", precision: 14, scale: 4
    t.decimal "district_tax_rate", precision: 14, scale: 4
    t.index ["location_id"], name: "index_tax_rates_on_location_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.boolean "active", default: false
    t.boolean "confirmed", default: false
    t.string "persistence_token"
    t.string "perishable_token"
  end

  create_table "vehicle_registrations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "vehicle_id"
    t.date "date_effective"
    t.date "date_expiration"
    t.text "notes"
    t.index ["vehicle_id"], name: "index_vehicle_registrations_on_vehicle_id"
  end

  create_table "vehicles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "original_location_id"
    t.bigint "location_id"
    t.string "vehicle_type"
    t.string "vin"
    t.string "license_number"
    t.string "make"
    t.string "model"
    t.integer "year"
    t.string "color"
    t.integer "original_odometer"
    t.string "transmission"
    t.string "power_train"
    t.integer "cylinders"
    t.string "fuel_grade"
    t.integer "tank_size"
    t.text "notes"
    t.string "status"
    t.index ["location_id"], name: "index_vehicles_on_location_id"
    t.index ["original_location_id"], name: "index_vehicles_on_original_location_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
