# == Schema Information
#
# Table name: insurance_policies
#
#  id                 :bigint(8)        not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :bigint(8)
#  driver_id          :bigint(8)
#  company_name       :string
#  agent              :string
#  policy_number      :string
#  phone_number       :string
#  effective_date     :date
#  expiration_date    :date
#  verify_date        :date
#  verify_agent       :string
#  verify_call_center :string
#

class InsurancePolicy < ApplicationRecord

  belongs_to :user
  belongs_to :driver

end
