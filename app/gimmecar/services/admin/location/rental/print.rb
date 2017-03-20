class Services::Admin::Location::Rental::Print < Lib::Services::Base

  attr_reader :rental

  def initialize(rental_number: nil, rental_id: nil)
    case
    when rental_number
      @rental = ::Rental.find_by(number: rental_number)
    when rental_id
      @rental = ::Rental.find_by(id: id)
    end
  end

  def fetch
    {
      :vehicle                                              => rental.vehicle_make_model,
      :location                                             => "Super 8 Redlands - 1160 Arizona St. Redlands, CA 92374",
      :name                                                 => rental.driver_name,
      :pickup                                               => rental.pickup,
      :drop_off                                             => rental.drop_off,
      :line_items                                           => rental.line_items,
      :total                                                => rental.total,
      :additional_driver_name                               => rental.additional_driver_name,
      :driver_financial_responsibility_signature            => rental.driver_financial_responsibility_signature,
      :additional_driver_financial_responsibility_signature => rental.additional_driver_financial_responsibility_signature,
      :driver_signature                                     => rental.driver_signature,
      :additional_driver_signature                          => rental.additional_driver_signature,
    }
  end
end
