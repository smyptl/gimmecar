class Services::Admin::Location::Rental::Print < Lib::Services::Base

  attr_reader :rental

  def initialize(rental_number: nil)
    @rental = ::Rental.find_by(number: rental_number)
  end

  def fetch
    {
      :vehicle                                              => rental.vehicle_make_model,
      :location                                             => rental.pickup_location_description,
      :name                                                 => rental.driver_name,
      :pickup                                               => rental.pickup,
      :drop_off                                             => rental.drop_off,
      :rates                                                => rental.line_items.where(:item_type => 'rental_rate'),
      :sub_total                                            => rental.sub_total,
      :tax_collectable                                      => rental.tax_collectable,
      :total                                                => rental.total,
      :combined_tax_rate                                    => rental.combined_tax_rate,
      :additional_driver_name                               => rental.additional_driver_name,
      :driver_financial_responsibility_signature            => rental.driver_financial_responsibility_signature,
      :additional_driver_financial_responsibility_signature => rental.additional_driver_financial_responsibility_signature,
      :driver_signature                                     => rental.driver_signature,
      :additional_driver_signature                          => rental.additional_driver_signature,
    }
  end
end
