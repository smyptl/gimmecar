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
      n.string :zip_code
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

  validate :add_one_contact

  with_options if: :add_email do
    validates :email_email,
      presence: true,
      email: true
  end

  with_options if: :add_address do
    validates :address_street1, :address_city, :address_state, :address_zip_code,
      presence: true
  end

  with_options if: :add_phone_number do
    validates :phone_number_number,
      presence: true,
      numericality: { only_integer: true }
  end

  private

  def add_one_contact
    unless add_email || add_address || add_phone_number
      errors.add(:base, 'Must add at least one contact info.')
    end
  end

  def success_args
    {
      driver_id: params.fetch(:driver_id)
    }
  end

  def save
    save_email
    save_address
    save_phone_number
  end

  def save_email
    if add_email
      Email.create(email.merge(owner: driver))
    end
  end

  def save_address
    if add_address
      Address.create(address.merge(owner: driver))
    end
  end

  def save_phone_number
    if add_phone_number
      PhoneNumber.create(phone_number.merge(owner: driver))
    end
  end

  def driver
    @driver ||= Driver.find(params.fetch(:driver_id))
  end
end
