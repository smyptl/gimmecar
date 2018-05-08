# == Schema Information
#
# Table name: phone_numbers
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_type :string
#  owner_id   :bigint(8)
#  phone_type :string
#  number     :string
#  extension  :string
#  notes      :text
#

class PhoneNumber < ApplicationRecord

  TYPES = ['cell', 'home', 'work', 'other']

  belongs_to :owner, polymorphic: true

end
