# == Schema Information
#
# Table name: line_items
#
#  id           :integer          not null, primary key
#  invoice_type :string
#  invoice_id   :integer
#  details      :json
#  item_type    :string
#  amount       :integer
#  tax          :integer
#

class LineItem < ApplicationRecord

  belongs_to :invoice, polymorphic: true

  def total
    amount + tax
  end
end
