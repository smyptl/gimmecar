class CreateCharges < ActiveRecord::Migration[5.1]
  def change
    create_table :charges do |t|
      t.timestamps
      t.references :owner, polymorphic: true, index: true
      t.string :stripe_charge_id
      t.integer :amount, limit: 8
      t.boolean :deposit, default: false
    end
  end
end
