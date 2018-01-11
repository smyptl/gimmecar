class AddDescription < ActiveRecord::Migration[5.1]
  def change
    add_column :line_items, :description, :text
  end
end
