class CreateLineItems < ActiveRecord::Migration[5.0]
  def change
    create_table :line_items do |t|
      t.timestamps
      t.references :invoice, polymorphic: true, index: true
      t.json :details
      t.string :item_type
      t.date :date
      t.integer :charge_id, index: true
      t.integer :tax_rate_id, index: true
      t.integer :amount, limit: 8
      t.integer :taxable_amount, limit: 8
      t.integer :tax_collectable, limit: 8
      t.integer :state_taxable_amount, limit: 8
      t.integer :state_amount, limit: 8
      t.integer :county_taxable_amount, limit: 8
      t.integer :county_amount, limit: 8
      t.integer :city_taxable_amount, limit: 8
      t.integer :city_amount, limit: 8
      t.integer :district_taxable_amount, limit: 8
      t.integer :district_amount, limit: 8
    end
  end
end
