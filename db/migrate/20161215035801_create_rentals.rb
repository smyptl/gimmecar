class CreateRentals < ActiveRecord::Migration[5.0]
  def change
    create_table :rentals do |t|
      t.timestamp
      t.belongs_to :driver
      t.belongs_to :vehicle
      t.string :status
      t.text :notes
      t.belongs_to :pickup_location
      t.date :pickup_date
      t.time :pickup_time
      t.integer :pickup_odometer
      t.integer :pickup_fuel
      t.belongs_to :return_location
      t.date :return_date
      t.time :return_time
      t.integer :return_odometer
      t.integer :return_fuel
      t.string :vehicle_type
    end
  end
end
