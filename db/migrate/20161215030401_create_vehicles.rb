class CreateVehicles < ActiveRecord::Migration[5.0]
  def change
    create_table :vehicles do |t|
      t.timestamp
      t.belongs_to :original_location
      t.belongs_to :location
      t.string :vehicle_type
      t.string :vin
      t.string :license_number
      t.string :make
      t.string :model
      t.integer :year
      t.string :color
      t.integer :original_odometer
      t.string :transmission
      t.string :power_train
      t.integer :cylinders
      t.string :fuel_grade
      t.integer :tank_size
      t.text :notes
    end
  end
end