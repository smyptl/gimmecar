class Services::Builders::RentalsTable < Lib::Services::Builder

  component do |c|
    c.attributes :status,
      :number,
      :driver_name,
      :vehicle_make_model,
      :pickup,
      :drop_off
  end
end
