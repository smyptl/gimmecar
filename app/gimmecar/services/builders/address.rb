class Services::Builders::Address < Lib::Services::Builder

  component do |c|
    c.attributes :address_type,
      :street1,
      :street2,
      :city,
      :state,
      :zip_code,
      :primary
  end
end
