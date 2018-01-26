module Actions::Admin::Location::Rental::New::Concerns::Driver
  extend ActiveSupport::Concern

  included do
    attributes do |a|
      a.integer :driver_id
      a.nested :driver do |n|
        n.string  :name_first
        n.string  :name_middle
        n.string  :name_last
        n.string  :license_number
        n.string  :license_state
        n.string  :license_country
        n.date    :license_expiration_date
        n.string  :address_1
        n.string  :address_2
        n.string  :city
        n.string  :state
        n.string  :zip_code
        n.string  :country
        n.string  :gender
        n.date    :date_of_birth
        n.string  :email
        n.integer :cell_phone_number
        n.integer :home_phone_number

        n.nested :insurance do |i|
          i.string  :company_name
          i.string  :policy_number
          i.integer :phone_number
          i.date    :effective_date
          i.date    :expiration_date
          i.string  :agent

          i.boolean :verified
          i.date    :verify_date
          i.string  :verify_agent
          i.string  :verify_call_center
        end
      end

      a.boolean :add_additional_driver

      a.integer :additional_driver_id
      a.nested :additional_driver do |n|
        n.string  :name_first
        n.string  :name_middle
        n.string  :name_last
        n.string  :license_number
        n.string  :license_state
        n.string  :license_country
        n.date    :license_expiration_date
        n.string  :address_1
        n.string  :address_2
        n.string  :city
        n.string  :state
        n.string  :zip_code
        n.string  :country
        n.string  :gender
        n.date    :date_of_birth
        n.string  :email
        n.integer :cell_phone_number
        n.integer :home_phone_number
      end
    end

    validates :driver_name_first, :driver_name_last,
      presence: true

    validates :driver_license_number, :driver_license_state,
      presence: true

    validates :driver_license_country,
      presence: true

    validates :driver_license_expiration_date,
      presence: true,
      after_date: -> { drop_off }

    validates :driver_address_1, :driver_city, :driver_state, :driver_zip_code,
      presence: true

    validates :driver_country,
      presence: true

    validates :driver_gender,
      inclusion: { in: ['male', 'female'], message: "%{value} is not a valid gender" }

    validates :driver_date_of_birth,
      presence: true,
      before_date: -> { Date.today - 21.years }

    validates :driver_email,
      presence: true,
      email: true

    validates :driver_cell_phone_number,
      presence: true,
      numericality: { only_integer: true }

    validates :driver_home_phone_number,
      allow_blank: true,
      numericality: { only_integer: true }

    validates :driver_insurance_company_name, :driver_insurance_policy_number,
      presence: true

    validates :driver_insurance_effective_date,
      presence: true,
      before_date: -> { pickup }

    validates :driver_insurance_expiration_date,
      presence: true,
      after_date: { with: -> { drop_off }, allow_nil: true }

    with_options if: :driver_insurance_verified do |a|
      a.validates :driver_insurance_verify_date, :driver_insurance_verify_agent, :driver_insurance_verify_call_center,
        presence: true
    end

    with_options if: :add_additional_driver do |a|
      a.validates :additional_driver_name_first, :additional_driver_name_last,
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
        inclusion: { in: %w(male female), message: "%{value} is not a valid gender" }

      a.validates :additional_driver_date_of_birth,
        presence: true,
        before_date: -> { Date.today - 21.years }

      a.validates :additional_driver_email,
        presence: true,
        email: true

      a.validates :additional_driver_cell_phone_number,
        presence: true,
        numericality: { only_integer: true }

      a.validates :additional_driver_home_phone_number,
        allow_blank: true,
        numericality: { only_integer: true }
    end
  end

  def drop_off
    raise Lib::Errors::NotImplemented
  end

  def pickup
    raise Lib::Errors::NotImplemented
  end
end
