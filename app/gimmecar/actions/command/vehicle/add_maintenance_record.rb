class Actions::Command::Vehicle::AddRegistration < Lib::Actions::Base

  attributes do |a|
    a.date :date
    a.integer :cost

    a.nested :items do |n|
      n.string :item_type
      n.integer :amount
    end
  end
end
