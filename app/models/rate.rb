# == Schema Information
#
# Table name: rates
#
#  id           :bigint(8)        not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  location_id  :bigint(8)
#  amount       :bigint(8)
#  vehicle_type :string
#

class Rate < ApplicationRecord

  belongs_to :location

end
