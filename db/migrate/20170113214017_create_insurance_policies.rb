class CreateInsurancePolicies < ActiveRecord::Migration[5.0]
  def change
    create_table :insurance_policies do |t|
      t.timestamp
      t.belongs_to :user
      t.date :confirmation_date
      t.belongs_to :driver
      t.string :company
      t.string :agent
      t.string :policy_number
      t.string :phone_number
      t.date :effective_date
      t.date :expiration_date
    end
  end
end
