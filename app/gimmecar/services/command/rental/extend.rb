class Services::Command::Rental::Extend < Lib::Services::Base

  attr_reader :rental

  attributes do |a|
    a.string :number
  end

  output do
    object :rental do |o|
      o.attributes :rental_last_rate_amount, :drop_off

      o.object :driver do |o|
        o.attributes :name, :stripe_id, :stripe_sources, :stripe_default_source
      end

      o.object :additional_driver do |o|
        o.attributes :name, :stripe_id, :stripe_sources, :stripe_default_source
      end
    end
  end

  def query
    Rental.includes(:rental_rates, :driver, :additional_driver).find_by(number: number)
  end
end
