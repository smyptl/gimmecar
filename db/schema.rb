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

ActiveRecord::Schema.define(version: 20161219200030) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "drivers", force: :cascade do |t|
    t.string  "title"
    t.string  "first_name"
    t.string  "last_name"
    t.string  "gender"
    t.string  "address_1"
    t.string  "address_2"
    t.string  "city"
    t.string  "state"
    t.string  "zip_code"
    t.integer "phone_number"
    t.string  "email"
    t.date    "date_of_birth"
    t.string  "license_number"
    t.string  "license_state"
    t.string  "license_country"
    t.date    "license_expiration_date"
    t.string  "insurance_company"
    t.string  "insurance_policy_number"
    t.string  "insurance_phone_number"
    t.boolean "do_not_rent"
    t.text    "notes"
  end

  create_table "rates", force: :cascade do |t|
    t.integer "location_id"
    t.date    "date"
    t.integer "rate"
    t.string  "vehicle_type"
    t.index ["location_id"], name: "index_rates_on_location_id", using: :btree
  end

  create_table "rentals", force: :cascade do |t|
    t.integer "driver_id"
    t.integer "vehicle_id"
    t.string  "status"
    t.text    "notes"
    t.integer "pickup_location_id"
    t.date    "pickup_date"
    t.time    "pickup_time"
    t.integer "pickup_odometer"
    t.integer "pickup_fuel"
    t.integer "return_location_id"
    t.date    "return_date"
    t.time    "return_time"
    t.integer "return_odometer"
    t.integer "return_fuel"
    t.string  "vehicle_type"
    t.index ["driver_id"], name: "index_rentals_on_driver_id", using: :btree
    t.index ["pickup_location_id"], name: "index_rentals_on_pickup_location_id", using: :btree
    t.index ["return_location_id"], name: "index_rentals_on_return_location_id", using: :btree
    t.index ["vehicle_id"], name: "index_rentals_on_vehicle_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.string  "email"
    t.string  "crypted_password"
    t.string  "password_salt"
    t.string  "persistence_token"
    t.string  "single_access_token"
    t.string  "perishable_token"
    t.boolean "active",              default: false
    t.boolean "confirmed",           default: false
  end

  create_table "vehicles", force: :cascade do |t|
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
  end

end
