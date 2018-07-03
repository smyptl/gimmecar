# == Schema Information
#
# Table name: charges
#
#  id               :bigint(8)        not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  owner_type       :string
#  owner_id         :bigint(8)
#  stripe_charge_id :string
#  amount           :bigint(8)
#  deposit          :boolean          default(FALSE)
#

class Charge < ApplicationRecord

  belongs_to :owner, polymorphic: true
  has_many :line_items

  def execute(success, failure, token: nil, source_id: nil, customer_id: nil)
    raise ArgumentError if amount.nil?

    begin
      customer_id = find_or_create_customer(token: token, customer_id: customer_id)

      unless amount == 0
        charge = Stripe::Charge.create({
          amount:   amount,
          currency: 'usd',
          customer: customer_id,
          source:   source_id,
        })
      end

      success.call(charge: self, customer_id: customer_id)
    rescue Stripe::CardError => e
      failure.call(message: e.message, customer_id: customer_id)
    else
      write_attribute(:stripe_charge_id, charge['id'])
    end
  end

  private

  def find_or_create_customer(token:, customer_id:)
    case
    when customer_id.blank? && token.blank?
      raise ArgumentError 'customer_id and token missing'
    when customer_id.blank? && token.present?
      Stripe::Customer.create({ source: token })['id']
    when customer_id.present? && token.present?
      customer = Stripe::Customer.retrieve(customer_id)
      customer.source = token
      customer.save
      customer.id
    when customer_id.present? && token.blank?
      customer_id
    else
      raise NotImplementedError
    end
  end
end
