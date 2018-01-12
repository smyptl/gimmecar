class CreateVehicles < ActiveRecord::Migration[5.1]
  def change
    create_table :vehicles do |t|
      t.timestamps
      t.belongs_to :original_location, index: true
      t.belongs_to :location, index: true
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
      t.string :status
    end
  end
end
