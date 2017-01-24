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

ActiveRecord::Schema.define(version: 20170113214017) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "drivers", force: :cascade do |t|
    t.string  "title"
    t.string  "first_name"
    t.string  "last_name"
    t.string  "name"
    t.string  "gender"
    t.string  "address_1"
    t.string  "address_2"
    t.string  "city"
    t.string  "state"
    t.string  "zip_code"
    t.string  "country"
    t.integer "home_phone_number"
    t.integer "cell_phone_number"
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
    t.date    "confirmation_date"
    t.integer "driver_id"
    t.string  "company"
    t.string  "agent"
    t.string  "policy_number"
    t.string  "phone_number"
    t.date    "effective_date"
    t.date    "expiration_date"
    t.index ["driver_id"], name: "index_insurance_policies_on_driver_id", using: :btree
    t.index ["user_id"], name: "index_insurance_policies_on_user_id", using: :btree
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
    t.integer "rate"
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
    t.integer  "pickup_odometer"
    t.float    "pickup_fuel"
    t.integer  "drop_off_location_id"
    t.datetime "drop_off"
    t.integer  "drop_off_odometer"
    t.float    "drop_off_fuel"
    t.boolean  "collision_damage_waiver"
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
    t.integer "original_odometer"
    t.string  "transmission"
    t.string  "power_train"
    t.integer "cylinders"
    t.string  "fuel_grade"
    t.integer "tank_size"
    t.text    "notes"
    t.index ["location_id"], name: "index_vehicles_on_location_id", using: :btree
    t.index ["original_location_id"], name: "index_vehicles_on_original_location_id", using: :btree
  end

end
