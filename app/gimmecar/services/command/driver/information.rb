class Services::Command::Driver::Information < Lib::Services::Base

  attributes do |a|
    a.integer :id
  end

  output do
    object :driver, component: Services::Builders::Driver do |o|
      o.attribute :rentals_closed_count, output: -> (driver) { driver.rentals_closed.count }

      o.nested :actions do |n|
        n.nested :add_card do |n|
          n.attribute :url, output: -> (d) { urls.command_driver_add_card_path(driver_id: d.id) }
        end

        n.nested :add_contact_info do |n|
          n.attribute :url, output: -> (d) { urls.command_driver_add_contact_info_path(driver_id: d.id) }
        end
      end
    end
  end

  private

  def query
    ::Driver.find(id)
  end
end
