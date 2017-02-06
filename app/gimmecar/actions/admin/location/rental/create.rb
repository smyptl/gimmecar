class Actions::Admin::Location::Rental::Create < Lib::Forms::Base
  include Lib::Forms::Actions

  attributes do |a|
    a.date_time :pickup
    a.date_time :drop_off

    a.nested :driver do |n|
      n.string  :first_name
      n.string  :last_name
      n.string  :license_number
      n.string  :license_state
      n.string  :license_country
      n.date    :license_expiration_date
      n.string  :address_1
      n.string  :address_2
      n.string  :city
      n.string  :state
      n.integer :zip_code
      n.string  :country
      n.string  :gender
      n.date    :date_of_birth
      n.integer :cell_phone_number
      n.integer :home_phone_number

      n.nested :insurance do |i|
        i.string :company_name
        i.string :policy_number
        i.string :phone_number
        i.date   :effective_date
        i.date   :expiration_date
        i.string :agent_name
      end
    end

    a.boolean :add_additional_driver

    a.nested :additional_driver do |n|
      n.string  :first_name
      n.string  :last_name
      n.string  :license_number
      n.string  :license_state
      n.string  :license_country
      n.date    :license_expiration_date
      n.string  :address_1
      n.string  :address_2
      n.string  :city
      n.string  :state
      n.integer :zip_code
      n.string  :country
      n.string  :gender
      n.date    :date_of_birth
      n.integer :cell_phone_number
      n.integer :home_phone_number
    end

    a.string :reference_code
    a.string :discount_code
  end
end
