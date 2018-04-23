class Services::Command::Rental::Extend < Lib::Services::Base

  attr_reader :rental

  attributes do |a|
    a.string :number
  end

  output do
    object :rental do |o|
      o.attributes :rental_last_rate_amount, :drop_off
    end
  end

  def query
    Rental.includes(:rental_rates).find_by(number: number)
  end
end
