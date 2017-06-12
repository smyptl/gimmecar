class CreateRentals < ActiveRecord::Migration[5.1]
  def change
    create_table :rentals do |t|
      t.timestamps
      t.string :number
      t.string :source
      t.string :status
      t.boolean :confirmed
      t.belongs_to :driver, index: true
      t.belongs_to :additional_driver, index: true
      t.belongs_to :vehicle, index: true
      t.belongs_to :tax_rate, index: true
      t.string :vehicle_type
      t.text :notes
      t.belongs_to :pickup_location, index: true
      t.datetime :pickup
      t.integer :pickup_odometer, limit: 8
      t.float :pickup_fuel
      t.belongs_to :drop_off_location, index: true
      t.datetime :drop_off
      t.integer :drop_off_odometer, limit: 8
      t.float :pickup_fuel
      t.float :drop_off_fuel
      t.boolean :collision_damage_waiver
      t.text :driver_financial_responsibility_signature
      t.text :additional_driver_financial_responsibility_signature
      t.text :driver_signature
      t.text :additional_driver_signature
    end
  end
end
