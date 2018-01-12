# == Schema Information
#
# Table name: rates
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  location_id  :integer
#  amount       :integer
#  vehicle_type :string
#

class Rate < ApplicationRecord

  belongs_to :location

end
