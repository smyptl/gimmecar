class Services::Command::Rental::Extend < Lib::Services::Base

  attr_reader :rental

  attributes do |a|
    a.string :number
  end

  output do
    object :rental do |o|
      o.attributes :last_rental_rate, :drop_off
    end
  end

  def query
    Rental.includes(:rates).find_by(number: number)
  end
end
