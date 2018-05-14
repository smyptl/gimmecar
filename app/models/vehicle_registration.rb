# == Schema Information
#
# Table name: vehicle_registrations
#
#  id              :bigint(8)        not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  vehicle_id      :bigint(8)
#  date_effective  :date
#  date_expiration :date
#  notes           :text
#

class VehicleRegistration < ApplicationRecord

  belongs_to :vehicle

  has_one_attached :document
end
