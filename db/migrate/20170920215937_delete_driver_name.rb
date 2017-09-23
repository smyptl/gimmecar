class DeleteDriverName < ActiveRecord::Migration[5.1]
  def change
    remove_column :drivers, :first_name
    remove_column :drivers, :last_name
  end
end
