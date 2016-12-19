# == Schema Information
#
# Table name: rates
#
#  id           :integer          not null, primary key
#  location_id  :integer
#  date         :date
#  rate         :integer
#  vehicle_type :string
#

class Rate < ApplicationRecord

  WEEKLY_DISCOUNT = 0.08
  MONTHLY_DISCOUNT = 0.15

end
