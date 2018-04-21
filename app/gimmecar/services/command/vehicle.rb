class Services::Command::Vehicle < Lib::Services::Base

  attributes do |a|
    a.string :vin
  end

  output do
    object :vehicle, component: Services::Builders::Vehicle do |o|
      o.attributes :fuel_level, :odometer

      o.nested :actions do |n|
        n.nested :add_registration do |n|
          n.attribute :url, output: -> (v) { urls.command_vehicle_add_registration_path(vehicle_id: v.vin) }
        end
      end
    end
  end

  private

  def query
    Vehicle.includes(:location, :rental_latest).find_by(vin: vin)
  end
end
