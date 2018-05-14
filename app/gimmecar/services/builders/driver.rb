class Services::Builders::Driver < Lib::Services::Builder

  component do |c|
    c.attributes :gender,
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

    c.collection :emails,        nested: true, component: Services::Builders::Email
    c.collection :phone_numbers, nested: true, component: Services::Builders::PhoneNumber
    c.collection :addresses,     nested: true, component: Services::Builders::Address

    c.attribute :do_not_rent, as: :do_not_rent?
  end
end
