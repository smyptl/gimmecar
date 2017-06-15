# == Schema Information
#
# Table name: charges
#
#  id               :integer          not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  owner_type       :string
#  owner_id         :integer
#  stripe_charge_id :string
#  amount           :integer
#  deposit          :boolean          default(FALSE)
#

class Charge < ApplicationRecord

  belongs_to :owner, polymorphic: true
  has_many :line_items

  def execute(success, failure, create_customer: false, token: nil, customer_id: nil)
    raise ArgumentError if amount.nil?

    begin
      case
      when create_customer
        customer_id = Stripe::Customer.create({ :source => token })['id']
      when !token.blank?
        raise ArugmentError if customer_id.nil?

        customer = Stripe::Customer.retrieve(customer_id)
        customer.source = token
        customer.save
      end

      unless amount == 0
        charge = Stripe::Charge.create({
          :amount   => amount,
          :currency => 'usd',
          :customer => customer_id,
        })

        write_attribute(:stripe_charge_id, charge['id'])
      end

      success.call(charge: self, customer_id: customer_id)

    rescue Stripe::CardError => e
      failure.call(message: e.message, customer_id: customer_id)
    end
  end
end
