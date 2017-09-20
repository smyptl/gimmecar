class AddDriverNames < ActiveRecord::Migration[5.1]
  def change
    add_column :drivers, :name_first, :string
    add_column :drivers, :name_middle, :string
    add_column :drivers, :name_last, :string
  end
end
