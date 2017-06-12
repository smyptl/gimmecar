class CreateRates < ActiveRecord::Migration[5.1]
  def change
    create_table :rates do |t|
      t.timestamps
      t.belongs_to :location
      t.boolean :default, default: false
      t.date :date
      t.integer :amount, limit: 8
      t.string :vehicle_type
    end

    create_table :rental_rates do |t|
      t.timestamps
      t.belongs_to :rental
      t.date :date
      t.integer :amount, limit: 8
    end
  end
end
