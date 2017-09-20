user = User.create({
  :first_name            => Faker::Name.first_name,
  :last_name             => Faker::Name.last_name,
  :email                 => 'test@gimmecar.com',
  :password              => '1234',
  :password_confirmation => '1234',
})

location = Location.create({
  :name      => 'Hotel California',
  :slug      => 'hotel-california',
  :address_1 => Faker::Address.street_address,
  :city      => 'Beverly Hills',
  :state     => 'California',
  :zip_code  => 90210,
  :country   => 'United States',
  :latitude  => Faker::Address.latitude,
  :longitude => Faker::Address.longitude,
})

user.locations << location

location.rates << Rate.create_default({ :amount => 3300, :vehicle_type => :mid_size })
location.rates << Rate.create_default({ :amount => 3000, :vehicle_type => :compact })
location.rates << Rate.create_default({ :amount => 3000, :vehicle_type => :pick_up })

location.tax_rates << TaxRate.create({
  :combined_tax_rate => 0.07750,
  :state_tax_rate    => 0.06000,
  :county_tax_rate   => 0.00250,
  :city_tax_rate     => 0.00000,
  :district_tax_rate => 0.01500,
})

location.vehicles << Vehicle.create({
  :original_location => location,
  :vehicle_type      => 'compact',
  :vin               => Faker::Vehicle.vin,
  :license_number    => '6TRJ244',
  :make              => 'Toyota',
  :model             => 'Corolla',
  :year              => 2017,
  :color             => 'white',
  :original_odometer => 12,
})

location.vehicles << Vehicle.create({
  :original_location => location,
  :vehicle_type      => 'mid_size',
  :vin               => Faker::Vehicle.vin,
  :license_number    => '8ASJ123',
  :make              => 'Toyota',
  :model             => 'Corolla',
  :year              => 2017,
  :color             => 'black',
  :original_odometer => 52,
})

rental_vehicle = Vehicle.create({
  :location          => location,
  :original_location => location,
  :vehicle_type      => 'pick_up',
  :vin               => Faker::Vehicle.vin,
  :license_number    => '8ASJ123',
  :make              => 'Toyota',
  :model             => 'Tundra',
  :year              => 2016,
  :color             => 'black',
  :original_odometer => 30,
})

rental_driver = Driver.create({
  :name_first              => Faker::Name.first_name,
  :name_middle             => Faker::Name.first_name,
  :name_last               => Faker::Name.last_name,
  :address_1               => Faker::Address.street_address,
  :address_2               => Faker::Address.secondary_address,
  :city                    => Faker::Address.city,
  :state                   => 'California',
  :zip_code                => Faker::Address.zip_code,
  :country                 => 'United States',
  :cell_phone_number       => "9091231234",
  :home_phone_number       => "9091239021",
  :gender                  => ['male', 'female'].sample,
  :email                   => Faker::Internet.email,
  :date_of_birth           => Date.today - 26.years,
  :license_number          => '123JAS12',
  :license_state           => 'California',
  :license_country         => 'United States',
  :license_expiration_date => Date.today + 1.year,
})

Rental.create_open({
  :driver                  => rental_driver,
  :vehicle                 => rental_vehicle,
  :vehicle_type            => 'pick_up',
  :pickup_location         => location,
  :pickup                  => DateTime.now - 1.day,
  :pickup_odometer         => 14500,
  :pickup_fuel             => 10,
  :drop_off_location       => location,
  :drop_off                => DateTime.now + 2.days,
  :collision_damage_waiver => false,
})
