class CreateDrivers < ActiveRecord::Migration[5.1]
  def change
    create_table :drivers do |t|
      t.timestamps
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :country
      t.string :home_phone_number
      t.string :cell_phone_number
      t.string :email
      t.date :date_of_birth
      t.string :license_number
      t.string :license_state
      t.string :license_country
      t.date :license_expiration_date
      t.boolean :do_not_rent
      t.string :stripe_id
      t.text :notes
    end
  end
end
