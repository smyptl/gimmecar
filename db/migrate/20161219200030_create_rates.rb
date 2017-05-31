class CreateRates < ActiveRecord::Migration[5.0]
  def change
    create_table :rates do |t|
      t.timestamps
      t.belongs_to :location
      t.date :date
      t.integer :rate, limit: 8
      t.string :vehicle_type
    end
  end
end
