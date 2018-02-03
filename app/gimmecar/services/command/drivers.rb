class Services::Command::Drivers < Lib::Services::Base

  output do
    object :driver, logic: Logic::Driver do |o|
      o.id :id

      o.values :name_first,
                :name_middle,
                :name_last

      o.component Services::Components::DriverInformation

      o.value :do_not_rent, as: :do_not_rent?
      o.value :rentals_count, output: -> (d) { d.rentals.count }, if: -> (d) { d.rentals.any? }

      o.collection :randoms, output: Services::Components::Random do |c|
        c.value :add_extra
      end

      o.collection :rentals, as: :another_name do |c|
        c.id :number

        c.value :number
      end
    end
  end


  private

  def query
    Driver.includes(:rentals).all
  end
end
