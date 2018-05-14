class Services::Admin::Location::Rental::Close < Lib::Services::Base

  attributes do |a|
    a.string :number
  end

  output do
    object :rental do |o|
      o.attributes :pickup_fuel
    end
  end

  private

  def query
    Rental.find_by(number: number)
  end
end
