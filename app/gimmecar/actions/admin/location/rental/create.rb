class Actions::Admin::Location::Rental::Create < Lib::Forms::Base
  include Lib::Forms::Actions

  attributes do |a|
    a.date_time :pickup
    a.date_time :drop_off

    a.integer :driver_id
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
      n.string  :email
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
    a.signature :financial_responsibility_signature
    a.signature :driver_signature

    a.boolean :add_additional_driver

    a.integer :additional_driver_id
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
      n.string  :email
      n.integer :cell_phone_number
      n.integer :home_phone_number
    end
    a.signature :additional_driver_signature

    a.integer :vehicle_id
    a.integer :pickup_odometer
    a.integer :pickup_fuel

    a.string :promo_code

    a.string :card_selected
    a.string :strip_token
  end

  with_options if: :add_additional_driver do |a|
    a.validates :additional_driver_first_name, :additional_driver_last_name,
      presence: true

    a.validates :additional_driver_license_number, :additional_driver_license_state,
      presence: true

    a.validates :additional_driver_license_country,
      presence: true

    a.validates :additional_driver_license_expiration_date,
      presence: true,
      after_date: -> { drop_off }

    a.validates :additional_driver_address_1, :additional_driver_city, :additional_driver_state, :additional_driver_zip_code,
      presence: true

    a.validates :additional_driver_country,
      presence: true

    a.validates :additional_driver_gender,
      presence: true,
      inclusion: { in: %w(male female), message: "%{value} is not a valid gender" }

    a.validates :additional_driver_date_of_birth,
      presence: true,
      after_date: -> { Date.today - 21.years }

    a.validates :additional_driver_email,
      presence: true,
      email: true

    a.validates :additional_driver_phone_number,
      presence: true
  end
end
