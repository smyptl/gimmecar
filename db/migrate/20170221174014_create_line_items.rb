class CreateLineItems < ActiveRecord::Migration[5.0]
  def change
    create_table :line_items do |t|
      t.timestamp
      t.references :invoice, polymorphic: true, index: true
      t.json :details
      t.string :item_type
      t.integer :amount, limit: 8
      t.decimal :tax_rate, precision: 14, scale: 4
      t.integer :tax, limit: 8
    end
  end
end
