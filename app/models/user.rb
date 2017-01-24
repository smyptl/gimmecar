# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  first_name        :string
#  last_name         :string
#  email             :string
#  password_digest   :string
#  perishable_token  :string
#  active            :boolean          default(FALSE)
#  confirmed         :boolean          default(FALSE)
#

class User < ApplicationRecord
  include Concerns::User::Authentication

  has_and_belongs_to_many :locations

  def name
    "#{first_name} #{last_name}"
  end

  def to_javascript
    {
      :name => name,
    }
  end
end
