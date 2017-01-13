# == Schema Information
#
# Table name: drivers
#
#  id                      :integer          not null, primary key
#  title                   :string
#  first_name              :string
#  last_name               :string
#  gender                  :string
#  address_1               :string
#  address_2               :string
#  city                    :string
#  state                   :string
#  zip_code                :string
#  country                 :string
#  home_phone_number       :integer
#  cell_phone_number       :integer
#  email                   :string
#  date_of_birth           :date
#  license_number          :string
#  license_state           :string
#  license_country         :string
#  license_expiration_date :date
#  insurance_company       :string
#  insurance_agent         :string
#  insurance_policy_number :string
#  insurance_phone_number  :string
#  do_not_rent             :boolean
#  notes                   :text
#

class Driver < ApplicationRecord

  has_many :rentals

  def name
    "#{first_name} #{last_name}"
  end

  def do_not_rent?
    do_not_rent
  end
end
