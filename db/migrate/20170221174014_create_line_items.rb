class CreateLineItems < ActiveRecord::Migration[5.1]
  def change
    create_table :line_items do |t|
      t.timestamps
      t.references :invoice, polymorphic: true, index: true
      t.references :item, polymorphic: true, index: true
      t.belongs_to :charge, index: true
      t.json :details
      t.date :date
      t.integer :quantity
      t.integer :total, limit: 8
      t.integer :amount, limit: 8
      t.integer :discount, limit: 8
      t.integer :sub_total, limit: 8
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
