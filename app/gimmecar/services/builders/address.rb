class Services::Builders::Address < Lib::Services::Builder

  component do |c|
    c.attributes :address_1,
      :address_2,
      :city,
      :state,
      :zip_code
  end
end
