class AddVehicleInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :vehicles, :date_commissioned, :date
    add_column :vehicles, :date_decommissioned, :date
    add_column :vehicles, :purchase_price, :integer
  end
end
