class RemoveUnusedColumns < ActiveRecord::Migration[5.2]
  def change
    remove_columns :drivers,
      :address_1,
      :address_2,
      :city,
      :state,
      :zip_code,
      :country,
      :home_phone_number,
      :cell_phone_number,
      :email
  end
end
