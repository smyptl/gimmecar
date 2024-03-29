class Services::Command::Rental::Information < Lib::Services::Base

  attributes do |a|
    a.string :number
  end

  output do
    object :rental, component: Services::Builders::Rental, logic: Logic::Metrics::Rental do |o|
      o.attributes :pickup_location_name,
                   :pickup_location_slug,
                   :drop_off_location_name,
                   :drop_off_location_slug

      o.attributes :sub_total,
                   :days_paid,
                   :miles_driven,
                   :average_miles_per_day,
                   :average_rate,
                   :average_price_per_mile

      o.nested :actions do |n|
        n.nested :extend,         if: -> (r) { r.can_extend_rental? }  do |n|
          n.attribute :url, output: -> (r) { urls.command_rental_extend_path(rental_id: r.number) }
        end

        n.nested :return_deposit, if: -> (r) { r.can_return_deposit? } do |n|
          n.attribute :url, output: -> (r) { urls.command_rental_return_deposit_path(rental_id: r.number) }
        end
      end

      o.object :driver do |o|
        o.attribute :name
      end

      o.object :additional_driver do |o|
        o.attribute :name
      end

      o.object :vehicle do |o|
        o.attributes :make_model,
                     :vin,
                     :license_number
      end
    end
  end

  private

  def query
    Rental.includes(:vehicle, :pickup_location, :drop_off_location, :driver, :additional_driver).find_by(number: number)
  end
end
