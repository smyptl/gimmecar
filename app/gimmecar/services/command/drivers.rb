class Services::Command::Drivers < Lib::Services::Base

  output do
    collection :drivers, component: Services::Builders::Driver do |o| #, logic: Logic::Driver do |o|
      #o.component Services::Builders::Driver

      o.attribute :rentals_count, output: -> (d) { d.rentals.count }#, if: -> (d) { d.rentals.any? }

      o.collection :another_name, as: :rentals do |c|
        c.id :number
        c.attributes :number,
          :pickup,
          :drop_off
      end
    end
  end


  private

  def query
    Driver.includes(:rentals).all
  end
end
