class Services::Command::Rental < Lib::Services::Base

  attributes do |a|
    a.string :number
  end

  output do
    object :rental, component: Services::Builders::Rental do |o|
      o.attribute :pickup_location_name
    end
  end

  private

  def query
    Rental.includes(:vehicle, :pickup_location, :drop_off_location, :driver, :additional_driver).find_by(number: number)
  end
end
