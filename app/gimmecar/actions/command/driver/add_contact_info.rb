class Actions::Command::Driver::AddContactInfo < Lib::Actions::Base

  attributes do |a|
    a.boolean :add_email
    a.nested  :email do |n|
      n.string :email_type
      n.string :email
      n.string :notes
    end

    a.boolean :add_address
    a.nested :address do |n|
      n.string :address_type
      n.string :street1
      n.string :street2
      n.string :city
      n.string :state
      n.string :zip_cide
      n.string :notes
    end

    a.boolean :add_phone_number
    a.nested :phone_number do |n|
      n.string  :phone_type
      n.integer :number
      n.integer :extension
      n.string  :notes
    end
  end

  validates :email_email_type,
    presence: true


  private

  def save
    save_email
    save_address
    save_phone_number
  end

  def save_email
    if add_email
      Email.create(**email, owner: driver)
    end
  end

  def address
    if add_address
      Address.create(**address, owner: driver)
    end
  end

  def phone_number
    if add_phone_number
      PhoneNumber.create(**phone_number, owner: driver)
    end
  end

  def driver
    @driver ||= Driver.find(params.fetch(:driver_id))
  end
end
