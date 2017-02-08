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

location.vehicles << Vehicle.create({
  :original_location => location,
  :vehicle_type      => 'mid_size',
  :vin               => Faker::Vehicle.vin,
  :license_number    => '6TRJ244',
  :make              => 'Toyota',
  :model             => 'Corolla',
  :year              => 2017,
  :color             => 'white',
  :original_odometer => 12,
})
