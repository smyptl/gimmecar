class CreateRentals < ActiveRecord::Migration[5.0]
  def change
    create_table :rentals do |t|
      t.timestamp
      t.string :number
      t.string :source
      t.string :status
      t.boolean :confirmed
      t.belongs_to :driver
      t.belongs_to :additional_driver
      t.belongs_to :vehicle
      t.string :vehicle_type
      t.text :notes
      t.belongs_to :pickup_location
      t.datetime :pickup
      t.integer :pickup_odometer
      t.float :pickup_fuel
      t.belongs_to :drop_off_location
      t.datetime :drop_off
      t.integer :drop_off_odometer
      t.float :drop_off_fuel
      t.boolean :collision_damage_waiver
    end
  end
end
