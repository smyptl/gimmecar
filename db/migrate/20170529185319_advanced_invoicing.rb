class AdvancedInvoicing < ActiveRecord::Migration[5.1]
  def change
    remove_column :line_items, :tax_rate
    add_column :line_items, :date, :date

    add_column :line_items, :charge_id, :integer, index: true
    add_column :line_items, :tax_rate_id, :integer, index: true

    add_column :line_items, :taxable_amount, :integer, limit: 8
    add_column :line_items, :tax_collectable, :integer, limit: 8
    add_column :line_items, :state_taxable_amount, :integer, limit: 8
    add_column :line_items, :state_amount, :integer, limit: 8
    add_column :line_items, :county_taxable_amount, :integer, limit: 8
    add_column :line_items, :county_amount, :integer, limit: 8
    add_column :line_items, :city_taxable_amount, :integer, limit: 8
    add_column :line_items, :city_amount, :integer, limit: 8
    add_column :line_items, :district_taxable_amount, :integer, limit: 8
    add_column :line_items, :district_amount, :integer, limit: 8

    create_table :tax_rates do |t|
      t.timestamps
      t.belongs_to :location, index: true
      t.decimal :combined_tax_rate, precision: 14, scale: 4
      t.decimal :state_tax_rate, precision: 14, scale: 4
      t.decimal :county_tax_rate, precision: 14, scale: 4
      t.decimal :city_tax_rate, precision: 14, scale: 4
      t.decimal :district_tax_rate, precision: 14, scale: 4
    end
  end
end
