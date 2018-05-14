class CreateEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.timestamps
      t.belongs_to :owner, polymorphic: true, index: true
      t.string :email_type
      t.string :email
      t.text :notes
      t.boolean :primary, default: false
    end
  end
end
