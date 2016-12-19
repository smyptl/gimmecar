# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  first_name          :string
#  last_name           :string
#  email               :string
#  crypted_password    :string
#  password_salt       :string
#  persistence_token   :string
#  single_access_token :string
#  perishable_token    :string
#  active              :boolean          default(FALSE)
#  confirmed           :boolean          default(FALSE)
#

class User < ApplicationRecord
  acts_as_authentic

  validates :first_name, :last_name,
    presence: true

  validates :email,
    uniqueness: true,
    presence: true,
    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  def name
    "#{first_name} #{last_name}"
  end
end
