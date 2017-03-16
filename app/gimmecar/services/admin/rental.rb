class Services::Admin::Rental < Lib::Services::Base

  attr_reader :rental

  def initialize(rental_number: nil, rental_id: nil)
    case
    when rental_number
      @rental = Rental.find_by(number: rental_number)
    when rental_id
      @rental = Rental.find_by(id: id)
    end
  end

  def fetch
    output = {}

    output[:number]                                               = rental.number
    output[:status]                                               = rental.status
    output[:driver]                                               = rental.driver
    output[:additional_driver_id]                                 = rental.additional_driver_id
    output[:vehicle]                                              = rental.vehicle
    output[:vehicle_type]                                         = rental.vehicle_type
    output[:notes]                                                = rental.notes
    output[:pickup_location_id]                                   = rental.pickup_location_id
    output[:pickup]                                               = rental.pickup
    output[:pickup_odometer]                                      = rental.pickup_odometer
    output[:pickup_fuel]                                          = rental.pickup_fuel
    output[:drop_off_location_id]                                 = rental.drop_off_location_id
    output[:drop_off]                                             = rental.drop_off
    output[:drop_off_odometer]                                    = rental.drop_off_odometer
    output[:drop_off_fuel]                                        = rental.drop_off_fuel
    output[:collision_damage_waiver]                              = rental.collision_damage_waiver
    output[:driver_financial_responsibility_signature]            = rental.driver_financial_responsibility_signature
    output[:additional_driver_financial_responsibility_signature] = rental.additional_driver_financial_responsibility_signature
    output[:driver_signature]                                     = rental.driver_signature
    output[:additional_driver_signature]                          = rental.additional_driver_signature

    output
  end
end
