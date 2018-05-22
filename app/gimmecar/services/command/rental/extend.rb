class Services::Command::Rental::Extend < Lib::Services::Base

  attr_reader :rental

  attributes do |a|
    a.string :number
  end

  output do
    object :rental do |o|
      o.attributes :rental_last_rate_amount, :drop_off
      o.attributes :driver_sources,            output: -> (r) { r.driver_stripe_sources }
      o.attributes :additional_driver_sources, output: -> (r) { r.additional_driver_stripe_sources }
    end
  end

  def query
    Rental.includes(:rental_rates, :driver, :additional_driver).find_by(number: number)
  end
end
