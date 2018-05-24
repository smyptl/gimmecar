class Services::Command::Rental::Extend < Lib::Services::Base

  attr_reader :rental

  attributes do |a|
    a.string :number
  end

  output do
    object :rental do |o|
      o.attributes :rental_last_rate_amount, :drop_off
      o.attributes :driver_name, :driver_stripe_id
      o.attribute :driver_sources,                   output: -> (r) { r.driver_stripe_sources }
      o.attribute :driver_default_source,            output: -> (r) { r.driver_stripe_default_source }
      o.attributes :additional_driver_name, :additional_driver_stripe_id
      o.attribute :additional_driver_sources,        output: -> (r) { r.additional_driver_stripe_sources }
      o.attribute :additional_driver_default_source, output: -> (r) { r.additional_driver_stripe_default_source }
    end
  end

  def query
    Rental.includes(:rental_rates, :driver, :additional_driver).find_by(number: number)
  end
end
