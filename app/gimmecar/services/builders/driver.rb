class Services::Builders::Driver < Lib::Services::Builder

  component do |c|
    c.attributes :gender,
      :address_1,
      :address_2,
      :city,
      :state,
      :zip_code,
      :country,
      :email,
      :date_of_birth,
      :license_number,
      :license_state,
      :license_country,
      :license_expiration_date,
      :stripe_id,
      :notes,
      :name_first,
      :name_middle,
      :name_last

    c.collection :phone_numbers, nested: true do |c|
      c.attributes :phone_type, :number, :extension, :notes
    end

    c.attribute :do_not_rent, as: :do_not_rent?
  end
end
