class Services::Admin::Vehicle < Lib::Services::Base

  attributes do |a|
    a.string :vin
  end

  output do
    object :vehicle do |o|
      o.id

      o.attributes :vin,
        :license_number,
        :make_model,
        :status,
        :year,
        :color

      o.attribute :vehicle_type, output: -> (v) { ActiveSupport::Inflector.titleize(v.vehicle_type) }
    end
  end

  private

  def query
    ::Vehicle.find_by(vin: vin)
  end
end
