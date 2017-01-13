class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.timestamp
      t.string :name
      t.string :slug
      t.string :latitude
      t.string :longitude
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :country
      t.string :phone_number
    end
  end
end
