# == Schema Information
#
# Table name: vehicle_registrations
#
#  id              :integer          not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  vehicle_id      :integer
#  date_effective  :date
#  date_expiration :date
#  notes           :text
#

class VehicleRegistration < ApplicationRecord

  belongs_to :vehicle

end
