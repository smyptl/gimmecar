class Services::Command::Driver::Information < Lib::Services::Base

  attributes do |a|
    a.integer :id
  end

  output do
    object :driver, component: Services::Builders::Driver do |o|
      o.attribute :rentals_closed_count, output: -> (driver) { driver.rentals_closed.count }
    end
  end

  private

  def query
    ::Driver.find(id)
  end
end
