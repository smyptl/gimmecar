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
        n.string  :gender
        n.date    :date_of_birth
        n.string  :email

        n.nested :address do |n|
          n.string  :street1
          n.string  :street2
          n.string  :city
          n.string  :state
          n.integer :zip_code
        end

        n.nested :phone_numbers do |n|
          n.integer :cell
          n.integer :home
        end

        #n.nested :phone_numbers, multiple: true do |n|
          #n.string :phone_type
          #n.integer :number
          #n.integer :extension
        #end

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
        n.string  :gender
        n.date    :date_of_birth
        n.string  :email

        n.nested :address do |n|
          n.string  :street1
          n.string  :street2
          n.string  :city
          n.string  :state
          n.integer :zip_code
        end

        n.nested :phone_numbers do |n|
          n.integer :cell
          n.integer :home
        end
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

    validates :driver_address_street1, :driver_address_city, :driver_address_state, :driver_address_zip_code,
      presence: true

    validates :driver_gender,
      inclusion: { in: ['male', 'female'], message: "%{value} is not a valid gender" }

    validates :driver_date_of_birth,
      presence: true,
      before_date: -> { Time.current.in_time_zone(time_zone).to_date - 21.years }

    validates :driver_email,
      presence: true,
      email: true

    validates :driver_phone_numbers_cell,
      presence: true,
      numericality: { only_integer: true }

    validates :driver_phone_numbers_home,
      allow_blank: true,
      numericality: { only_integer: true }

    validates :driver_insurance_company_name, :driver_insurance_policy_number,
      presence: true

    validates :driver_insurance_effective_date,
      presence: true,
      before_date: -> { pickup.in_time_zone(time_zone).to_date }

    validates :driver_insurance_expiration_date,
      presence: true,
      after_date: { with: -> { drop_off.in_time_zone(time_zone).to_date }, allow_nil: true }

    with_options if: :driver_insurance_verified do
      validates :driver_insurance_verify_date, :driver_insurance_verify_agent, :driver_insurance_verify_call_center,
        presence: true
    end

    with_options if: :add_additional_driver do
      validates :additional_driver_name_first, :additional_driver_name_last,
        presence: true

      validates :additional_driver_license_number, :additional_driver_license_state,
        presence: true

      validates :additional_driver_license_country,
        presence: true

      validates :additional_driver_license_expiration_date,
        presence: true,
        after_date: -> { drop_off }

      validates :additional_driver_address_street1, :additional_driver_address_city, :additional_driver_address_state, :additional_driver_address_zip_code,
        presence: true

      validates :additional_driver_gender,
        inclusion: { in: %w(male female), message: "%{value} is not a valid gender" }

      validates :additional_driver_date_of_birth,
        presence: true,
        before_date: -> { Time.current.in_time_zone(time_zone).to_date - 21.years }

      validates :additional_driver_email,
        presence: true,
        email: true

      validates :additional_driver_phone_numbers_cell,
        presence: true,
        numericality: { only_integer: true }

      validates :additional_driver_phone_numbers_home,
        allow_blank: true,
        numericality: { only_integer: true }
    end
  end

  def drop_off
    raise NotImplementedError
  end

  def pickup
    raise NotImplementedError
  end

  def time_zone
    raise NotImplementedError
  end
end
