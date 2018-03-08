class CreateRates < ActiveRecord::Migration[5.1]
  def change
    create_table :rates do |t|
      t.timestamps
      t.belongs_to :location
      t.integer :amount, limit: 8
      t.string :vehicle_type
    end
  end
end
