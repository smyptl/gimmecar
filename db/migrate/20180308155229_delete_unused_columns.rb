class DeleteUnusedColumns < ActiveRecord::Migration[5.1]
  def change
    remove_column :rentals, :vehicle_type
    remove_column :line_items, :item_id
  end
end
