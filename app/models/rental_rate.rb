# == Schema Information
#
# Table name: rental_rates
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  rental_id  :integer
#  date       :date
#  amount     :integer
#

class RentalRate < ApplicationRecord

  belongs_to :rental

end
