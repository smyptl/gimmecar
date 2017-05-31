class CreateTaxRates < ActiveRecord::Migration[5.1]
  def change
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
