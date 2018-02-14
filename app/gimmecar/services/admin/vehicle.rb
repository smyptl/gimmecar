class Services::Admin::Vehicle < Lib::Services::Base

  attributes do |a|
    a.string :vin
  end

  output do
    object :vehicle do |o|
      o.id

      o.values [
        :vin,
        :license_number,
        :make_model,
        :status,
        :year,
        :color
      ]

      o.value :vehicle_type, output: -> (v) { ActiveSupport::Inflector.titleize(v.vehicle_type) }
    end
  end

  private

  def query
    ::Vehicle.find_by(vin: vin)
  end
end
