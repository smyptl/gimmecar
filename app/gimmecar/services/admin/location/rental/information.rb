class Services::Admin::Location::Rental::Information < Lib::Services::Base

  attributes do |a|
    a.string :number
    a.string :slug
  end

  output do
    object :rental, component: Services::Builders::Rental do |o|
      o.object :driver,            component: Services::Builders::Driver
      o.object :additional_driver, component: Services::Builders::Driver
      o.object :vehicle,           component: Services::Builders::VehiclesTable

      o.nested :actions do |n|
        n.nested :close, if: -> (r) { r.can_close? }  do |n|
          n.attribute :url, output: -> (r) { urls.admin_location_rental_close_path(rental_id: r.number, slug: slug) }
        end
      end
    end
  end

  def query
    Rental.includes(:driver, :additional_driver, :vehicle).find_by(number: number)
  end
end
