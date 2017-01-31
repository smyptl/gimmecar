# == Schema Information
#
# Table name: insurance_policies
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  confirmation_date :date
#  driver_id         :integer
#  company           :string
#  agent             :string
#  policy_number     :string
#  phone_number      :string
#  effective_date    :date
#  expiration_date   :date
#

class InsurancePolicy < ApplicationRecord

  belongs_to :user
  belongs_to :driver

end
