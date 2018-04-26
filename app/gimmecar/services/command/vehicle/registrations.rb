class Services::Command::Vehicle::Registrations < Lib::Services::Base

  attributes do |a|
    a.string :vin
  end

  output do
    collection :registrations do |c|
      c.attributes :date_effective, :date_expiration
      c.attribute :url, output: -> (r) { urls.rails_blob_path(r.document, disposition: "attachment", only_path: true) }
    end
  end

  private

  def query
    Vehicle.includes(:vehicle_registrations).find_by(vin: vin).vehicle_registrations.order(date_expiration: :desc)
  end
end
