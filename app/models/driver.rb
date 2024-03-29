# == Schema Information
#
# Table name: drivers
#
#  id                      :bigint(8)        not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  gender                  :string
#  date_of_birth           :date
#  license_number          :string
#  license_state           :string
#  license_country         :string
#  license_expiration_date :date
#  do_not_rent             :boolean
#  stripe_id               :string
#  notes                   :text
#  name_first              :string
#  name_middle             :string
#  name_last               :string
#

class Driver < ApplicationRecord

  has_many :phone_numbers, as: :owner
  has_many :addresses,     as: :owner
  has_many :emails,        as: :owner
  has_one :address_primary, -> { primary }, as: :owner, class_name: 'Address'
  has_one :email_primary,   -> { primary }, as: :owner, class_name: 'Email'

  has_many :rentals,        -> (driver) { as(:driver, :additional_driver, id: driver.id) }
  has_many :rentals_closed, -> (driver) { as(:driver, :additional_driver, id: driver.id).closed_status }, class_name: 'Rental'
  has_many :insurance_policies

  scope :search, -> (name:, date_of_birth:) { FuzzyMatch.new(where(date_of_birth: date_of_birth), read: :name).find(name) }

  before_destroy { |record| throw :abort if record.rentals? }

  def retrieve_or_create_stripe_customer
    if stripe_id
      stripe_customer
    else
      customer = Stripe::Customer.create({ description: name, email: email_primary.try(:email) })
      update(stripe_id: customer['id'])
      customer
    end
  end

  def stripe_customer
    Stripe::Customer.retrieve(stripe_id) if stripe_id
  end

  def stripe_sources
    stripe_customer[:sources] if stripe_id
  end

  def stripe_default_source
    stripe_customer[:default_source] if stripe_id
  end

  def name
    "#{name_first} #{name_last}"
  end

  def name_full
    "#{name_first} #{name_middle} #{name_last}"
  end

  def rentals?
    rentals.any?
  end

  def do_not_rent?
    Lib::Attributes::TypeCast.boolean(do_not_rent)
  end
end
