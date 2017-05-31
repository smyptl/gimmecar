class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.timestamps
      t.string  :first_name
      t.string  :last_name
      t.string  :email
      t.string  :password_digest
      t.boolean :active, default: false
      t.boolean :confirmed, default: false
      t.string  :persistence_token
      t.string  :perishable_token
    end
  end
end
