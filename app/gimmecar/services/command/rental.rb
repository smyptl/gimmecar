class Services::Command::Rental < Lib::Services::Base

  attr_reader :rental

  def initialize(number: nil, id: nil)
    case
    when number
      @rental = Rental.find_by(number: number)
    when id
      @rental = Rental.find(id)
    end
  end

  def fetch
    output = {}

    output[:number]                                               = rental.number
    output[:status]                                               = rental.status
    output[:driver]                                               = rental.driver
    output[:additional_driver]                                    = rental.additional_driver
    output[:vehicle]                                              = rental.vehicle
    output[:vehicle_type]                                         = rental.vehicle_type
    output[:notes]                                                = rental.notes
    output[:pickup_location_id]                                   = rental.pickup_location_id
    output[:pickup_location_name]                                 = rental.pickup_location_name
    output[:pickup]                                               = rental.pickup
    output[:pickup_odometer]                                      = rental.pickup_odometer
    output[:pickup_fuel]                                          = rental.pickup_fuel
    output[:drop_off_location_id]                                 = rental.drop_off_location_id
    output[:drop_off_location_name]                               = rental.drop_off_location_name
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
