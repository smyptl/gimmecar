class Services::Admin::Location::Rentals < Lib::Services::Base

  output do
    collection :rentals do |o|
      c.id :number

      c.values [
        :driver_name,
        :vehicle_make_model,
        :pickup,
        :drop_off
      ]
    end
  end

  private

  def query
    Location.includes(open_rentals: :vehicle).find(params[:location_id])
  end
end
