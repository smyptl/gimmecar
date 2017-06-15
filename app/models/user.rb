# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  first_name        :string
#  last_name         :string
#  email             :string
#  password_digest   :string
#  active            :boolean          default(FALSE)
#  confirmed         :boolean          default(FALSE)
#  persistence_token :string
#  perishable_token  :string
#

class User < ApplicationRecord
  include Concerns::User::Authentication

  has_paper_trail :skip => [:password_digest]

  has_and_belongs_to_many :locations

  def name
    "#{first_name} #{last_name}"
  end

  def number_of_locations
    locations.count
  end
end
