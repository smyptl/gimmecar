class CreateInsurancePolicies < ActiveRecord::Migration[5.1]
  def change
    create_table :insurance_policies do |t|
      t.timestamps
      t.belongs_to :user, index: true
      t.belongs_to :driver, index: true
      t.string :company_name
      t.string :agent
      t.string :policy_number
      t.string :phone_number
      t.date :effective_date
      t.date :expiration_date

      t.date :verify_date
      t.string :verify_agent
      t.string :verify_call_center
    end
  end
end
