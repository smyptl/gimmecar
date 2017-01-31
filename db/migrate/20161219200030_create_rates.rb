class CreateRates < ActiveRecord::Migration[5.0]
  def change
    create_table :rates do |t|
      t.timestamp
      t.belongs_to :location
      t.date :date
      t.integer :rate
      t.string :vehicle_type
    end
  end
end
