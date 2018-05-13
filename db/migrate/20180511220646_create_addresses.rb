class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.timestamps
      t.belongs_to :owner, polymorphic: true, index: true
      t.string :address_type
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :zip_code
      t.text :notes
      t.boolean :primary, default: false
    end
  end
end
