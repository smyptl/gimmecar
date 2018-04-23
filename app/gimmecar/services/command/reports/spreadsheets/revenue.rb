class Services::Command::Reports::Spreadsheets::Revenue < Lib::Services::Base

  def output
    spreadsheet = Lib::Spreadsheet::Base.new('Revenue') do |ss|

      ::Location.all.each do |location|

        ss.add_sheet(location.name) do |s|

          s.show_grid_lines = false

          s.row(style: :head_title) do |r|
            r.value "#{location.name} - Revenue", merge_cells: :to_end
          end
          s.blank_row 1, style: :head, merge_cells: :to_end

          s.row(style: :head_header, height: nil) do |r|
            r.column "Rental #",                :rental,                  style: :align_left
            r.column "Item",                    :item_type,               style: :align_right
            r.column "Charge ID",               :charge_id,               style: :align_right
            r.column "Details",                 :details,                 style: :align_right
            r.column "Date",                    :date,                    style: :align_right
            r.column "Quantity",                :quantity,                style: :align_right
            r.column "Total",                   :total,                   style: :align_right
            r.column "Amount",                  :amount,                  style: :align_right
            r.column "Discount",                :discount,                style: :align_right
            r.column "Sub Total",               :sub_total,               style: :align_right
            r.column "Taxable Amount",          :taxable_amount,          style: :align_right
            r.column "Tax Collectable",         :tax_collectable,         style: :align_right
            r.column "State Taxable Amount",    :state_taxable_amount,    style: :align_right
            r.column "State Amount",            :state_amount,            style: :align_right
            r.column "County Taxable Amount",   :county_taxable_amount,   style: :align_right
            r.column "County Amount",           :county_amount,           style: :align_right
            r.column "City Taxable Amount",     :city_taxable_amount,     style: :align_right
            r.column "City Amount",             :city_amount,             style: :align_right
            r.column "District Taxable Amount", :district_taxable_amount, style: :align_right
            r.column "District Amount",         :district_amount,         style: :align_right
            r.column "Description",             :description,             style: :align_right
          end

          line_items = line_items(location)

          if line_items.any?
            s.row_for_each(line_items, group: :line_items, style: [:default, :border_bottom_light], height: :default) do |r, li|
              r.value li.invoice_number
              r.value li.item_type
              r.value li.charge_id
              r.value li.details
              r.value li.date, style: :date
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

            s.row(style: [:total, :total_border, :bold], height: :default) do |r|
              r.value      "Total"
              r.blank_cell 5
              r.formula    -> (f) { f.sum([f.range(rows: :line_items, column: :current)]) }
              r.formula    -> (f) { f.sum([f.range(rows: :line_items, column: :current)]) }
              r.formula    -> (f) { f.sum([f.range(rows: :line_items, column: :current)]) }
              r.formula    -> (f) { f.sum([f.range(rows: :line_items, column: :current)]) }
              r.formula    -> (f) { f.sum([f.range(rows: :line_items, column: :current)]) }
              r.formula    -> (f) { f.sum([f.range(rows: :line_items, column: :current)]) }
              r.formula    -> (f) { f.sum([f.range(rows: :line_items, column: :current)]) }
              r.formula    -> (f) { f.sum([f.range(rows: :line_items, column: :current)]) }
              r.formula    -> (f) { f.sum([f.range(rows: :line_items, column: :current)]) }
              r.formula    -> (f) { f.sum([f.range(rows: :line_items, column: :current)]) }
              r.formula    -> (f) { f.sum([f.range(rows: :line_items, column: :current)]) }
              r.formula    -> (f) { f.sum([f.range(rows: :line_items, column: :current)]) }
              r.formula    -> (f) { f.sum([f.range(rows: :line_items, column: :current)]) }
              r.formula    -> (f) { f.sum([f.range(rows: :line_items, column: :current)]) }
              r.blank_cell
            end
          end
        end
      end
    end
  end

  private

  def line_items(location)
    location.line_items.where(date: Date.new(2017, 10, 1)..Date.new(2017, 12, 31))
  end
end
