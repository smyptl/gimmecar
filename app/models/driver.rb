# == Schema Information
#
# Table name: drivers
#
#  id                      :integer          not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  gender                  :string
#  address_1               :string
#  address_2               :string
#  city                    :string
#  state                   :string
#  zip_code                :string
#  country                 :string
#  home_phone_number       :string
#  cell_phone_number       :string
#  email                   :string
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

  has_many :rentals
  has_many :insurance_policies

  before_destroy { |record| throw :abort if record.rentals? }

  #def self.search(name: nil, date_of_birth: nil, license_number: nil)
    #where("name_first LIKE ? OR name_last LIKE ? OR license_number LIKE ?", "%#{name}%", "%#{name}%", "%#{license_number}%")
  #end

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
