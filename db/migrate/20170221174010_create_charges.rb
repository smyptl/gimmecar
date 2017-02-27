class CreateCharges < ActiveRecord::Migration[5.0]
  def change
    create_table :charges do |t|
      t.timestamp
      t.references :owner, polymorphic: true, index: true
      t.string :stripe_charge_id
      t.json :details
      t.integer :sub_total
      t.json :discount
      t.json :fees
      t.decimal :tax_rate, precision: 10, scale: 4
      t.integer :tax
      t.integer :total
      t.boolean :deposit, default: false
    end
  end
end
