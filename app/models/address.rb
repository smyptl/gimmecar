# == Schema Information
#
# Table name: addresses
#
#  id           :bigint(8)        not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  owner_type   :string
#  owner_id     :bigint(8)
#  address_type :string
#  street1      :string
#  street2      :string
#  city         :string
#  state        :string
#  zip_code     :string
#  notes        :text
#  primary      :boolean          default(FALSE)
#

class Address < ApplicationRecord

  belongs_to :owner, polymorphic: true

  scope :primary, -> { where(primary: true) }

end
