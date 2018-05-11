def load_file(file_name)
  YAML.load(ERB.new(File.read(Rails.root.join('db', 'seeds', file_name))).result)
end

ActiveRecord::Base.transaction(requires_new: true) do
  # Load Users
  puts 'User'
  user = User.create(load_file('user.yml'))

  # Load Locations
  puts 'Locations'
  load_file('locations.yml').each do |values|
    location = Location.create(values['data'])

    values['tax_rates'].each do |x|
      location.tax_rates << TaxRate.create(x)
    end

    values['rates'].each do |x|
      location.rates << Rate.create(x)
    end

    user.locations << location
  end

  # Load Vehicles
  puts 'Vehicles'
  Vehicle.create(load_file('vehicles.yml'))

  # Load Drivers
  puts 'Drivers'
  load_file('drivers.yml').each do |values|
    driver = Driver.create(values['data'])

    values['phone_numbers'].each do |x|
      driver.phone_numbers << PhoneNumber.create(x)
    end
  end
end

rental_vehicle = Vehicle.first
rental_driver = Driver.first

Rental.create_open({
  tax_rate:                Location.first.latest_tax_rate,
  driver:                  rental_driver,
  vehicle:                 rental_vehicle,
  pickup_location:         Location.first,
  pickup:                  Time.current - 1.day,
  pickup_odometer:         14500,
  pickup_fuel:             10,
  drop_off_location:       Location.first,
  drop_off:                Time.current + 2.days,
  collision_damage_waiver: false,
})
