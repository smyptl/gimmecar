class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.timestamp
      t.string  :first_name
      t.string  :last_name
      t.string  :email
      t.string  :crypted_password
      t.string  :password_salt
      t.string  :persistence_token
      t.string  :single_access_token
      t.string  :perishable_token
      t.boolean :active, default: false
      t.boolean :confirmed, default: false
    end
  end
end
