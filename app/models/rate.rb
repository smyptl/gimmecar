# == Schema Information
#
# Table name: rates
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  location_id  :integer
#  default      :boolean          default(FALSE)
#  date         :date
#  amount       :integer
#  vehicle_type :string
#

class Rate < ApplicationRecord

  VEHICLE_TYPES = [
    :mid_size
  ]

  belongs_to :location

end
