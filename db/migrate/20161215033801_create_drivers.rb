class CreateDrivers < ActiveRecord::Migration[5.0]
  def change
    create_table :drivers do |t|
      t.timestamp
      t.string :title
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :country
      t.integer :home_phone_number
      t.integer :cell_phone_number
      t.string :email
      t.date :date_of_birth
      t.string :license_number
      t.string :license_state
      t.string :license_country
      t.date :license_expiration_date
      t.string :insurance_company
      t.string :insurance_agent
      t.string :insurance_policy_number
			t.string :insurance_phone_number
      t.boolean :do_not_rent
      t.text :notes
    end
  end
end
