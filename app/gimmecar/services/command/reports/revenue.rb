class Services::Command::Reports::Revenue

  attributes do |a|
    a.integer :location_id
  end

  def fetch
    spreadsheet = Lib::Spreadsheet::Base.new

    spreadsheet.add_sheet('Revenue') do |s|

      s.row_for_each(line_items) do |r, li|
        r.value li.invoice_number
        r.value li.total
        r.value li.item_type
        r.value li.charge_id
        r.value li.details
        r.value li.date
        r.value li.quantity
        r.value li.total
        r.value li.amount
        r.value li.discount
        r.value li.sub_total
        r.value li.taxable_amount
        r.value li.tax_collectable
        r.value li.state_taxable_amount
        r.value li.state_amount
        r.value li.county_taxable_amount
        r.value li.county_amount
        r.value li.city_taxable_amount
        r.value li.city_amount
        r.value li.district_taxable_amount
        r.value li.district_amount
        r.value li.description
      end
    end
  end

  private

  def line_items
    @line_items ||= Location.find(location_id).line_items.where(date: period.range)
  end
end
