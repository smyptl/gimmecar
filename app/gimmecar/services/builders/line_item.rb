class Services::Builders::LineItem < Lib::Services::Builder

  component do |c|
    c.attributes :item_type, :date, :total, :sub_total, :tax_collectable
  end
end
