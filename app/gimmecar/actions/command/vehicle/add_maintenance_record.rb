class Actions::Command::Vehicle::AddMaintenanceRecord < Lib::Actions::Base

  attributes do |a|
    a.date :date
    a.integer :cost

    a.nested :items, multiple: true do |n|
      n.string :item_type
      n.integer :amount
    end
  end
end
