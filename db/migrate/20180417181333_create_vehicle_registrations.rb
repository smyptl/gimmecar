class CreateVehicleRegistrations < ActiveRecord::Migration[5.2]
  def change
    create_table :vehicle_registrations do |t|
      t.timestamps
      t.belongs_to :vehicle, index: true
      t.date :date_effective
      t.date :date_expiration
      t.text :notes
    end
  end
end
