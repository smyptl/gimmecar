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

ActiveRecord::Schema.define(version: 20170227044837) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "charges", force: :cascade do |t|
    t.string  "owner_type"
    t.integer "owner_id"
    t.string  "stripe_charge_id"
    t.integer "amount"
    t.boolean "deposit",          default: false
    t.index ["owner_type", "owner_id"], name: "index_charges_on_owner_type_and_owner_id", using: :btree
  end

  create_table "drivers", force: :cascade do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.string  "gender"
    t.string  "address_1"
    t.string  "address_2"
    t.string  "city"
    t.string  "state"
    t.string  "zip_code"
    t.string  "country"
    t.string  "home_phone_number"
    t.string  "cell_phone_number"
    t.string  "email"
    t.date    "date_of_birth"
    t.string  "license_number"
    t.string  "license_state"
    t.string  "license_country"
    t.date    "license_expiration_date"
    t.boolean "do_not_rent"
    t.string  "stripe_id"
    t.text    "notes"
  end

  create_table "insurance_policies", force: :cascade do |t|
    t.integer "user_id"
    t.integer "driver_id"
    t.string  "company_name"
    t.string  "agent"
    t.string  "policy_number"
    t.string  "phone_number"
    t.date    "effective_date"
    t.date    "expiration_date"
    t.date    "verify_date"
    t.string  "verify_agent"
    t.string  "verify_call_center"
    t.index ["driver_id"], name: "index_insurance_policies_on_driver_id", using: :btree
    t.index ["user_id"], name: "index_insurance_policies_on_user_id", using: :btree
  end

  create_table "line_items", force: :cascade do |t|
    t.string  "invoice_type"
    t.integer "invoice_id"
    t.json    "details"
    t.string  "item_type"
    t.integer "amount"
    t.integer "tax"
    t.index ["invoice_type", "invoice_id"], name: "index_line_items_on_invoice_type_and_invoice_id", using: :btree
  end

  create_table "locations", force: :cascade do |t|
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
    t.integer "user_id"
    t.integer "location_id"
    t.index ["location_id"], name: "index_locations_users_on_location_id", using: :btree
    t.index ["user_id"], name: "index_locations_users_on_user_id", using: :btree
  end

  create_table "rates", force: :cascade do |t|
    t.integer "location_id"
    t.date    "date"
    t.decimal "rate",         precision: 10
    t.string  "vehicle_type"
    t.index ["location_id"], name: "index_rates_on_location_id", using: :btree
  end

  create_table "rentals", force: :cascade do |t|
    t.string   "number"
    t.string   "source"
    t.string   "status"
    t.boolean  "confirmed"
    t.integer  "driver_id"
    t.integer  "additional_driver_id"
    t.integer  "vehicle_id"
    t.string   "vehicle_type"
    t.text     "notes"
    t.integer  "pickup_location_id"
    t.datetime "pickup"
    t.decimal  "pickup_odometer",                                      precision: 10
    t.float    "pickup_fuel"
    t.integer  "drop_off_location_id"
    t.datetime "drop_off"
    t.decimal  "drop_off_odometer",                                    precision: 10
    t.float    "drop_off_fuel"
    t.boolean  "collision_damage_waiver"
    t.text     "driver_financial_responsibility_signature"
    t.text     "additional_driver_financial_responsibility_signature"
    t.text     "driver_signature"
    t.text     "additional_driver_signature"
    t.index ["additional_driver_id"], name: "index_rentals_on_additional_driver_id", using: :btree
    t.index ["driver_id"], name: "index_rentals_on_driver_id", using: :btree
    t.index ["drop_off_location_id"], name: "index_rentals_on_drop_off_location_id", using: :btree
    t.index ["pickup_location_id"], name: "index_rentals_on_pickup_location_id", using: :btree
    t.index ["vehicle_id"], name: "index_rentals_on_vehicle_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.string  "email"
    t.string  "password_digest"
    t.boolean "active",            default: false
    t.boolean "confirmed",         default: false
    t.string  "persistence_token"
    t.string  "perishable_token"
  end

  create_table "vehicles", force: :cascade do |t|
    t.integer "original_location_id"
    t.integer "location_id"
    t.string  "vehicle_type"
    t.string  "vin"
    t.string  "license_number"
    t.string  "make"
    t.string  "model"
    t.integer "year"
    t.string  "color"
    t.decimal "original_odometer",    precision: 10
    t.string  "transmission"
    t.string  "power_train"
    t.integer "cylinders"
    t.string  "fuel_grade"
    t.integer "tank_size"
    t.text    "notes"
    t.index ["location_id"], name: "index_vehicles_on_location_id", using: :btree
    t.index ["original_location_id"], name: "index_vehicles_on_original_location_id", using: :btree
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  end

end
