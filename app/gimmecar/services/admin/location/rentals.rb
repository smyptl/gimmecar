class Services::Admin::Location::Rentals < Lib::Services::Base

  output do
    collection :rentals do |c|
      c.values [
        :number,
        :driver_name,
        :vehicle_make_model,
        :pickup,
        :drop_off
      ]
    end
  end

  private

  def query
    Location.includes(open_rentals: :vehicle).find(params.fetch(:location_id)).open_rentals
  end
end
