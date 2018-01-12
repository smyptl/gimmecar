class DeleteRentalRate < ActiveRecord::Migration[5.1]
  def change
    drop_table :rental_rates
    remove_column :rates, :default
    remove_column :rates, :date
  end
end
