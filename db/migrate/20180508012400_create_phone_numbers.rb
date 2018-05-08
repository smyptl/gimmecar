class CreatePhoneNumbers < ActiveRecord::Migration[5.2]
  def change
    create_table :phone_numbers do |t|
      t.timestamps
      t.belongs_to :owner, polymorphic: true, index: true
      t.string :phone_type
      t.string :number
      t.string :extension
      t.text :notes
    end
  end
end
