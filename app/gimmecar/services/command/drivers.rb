class Services::Command::Drivers < Lib::Services::Base

  output do
    object :driver do |o|
      o.id :id

      #values :name_first,
              #:name_middle,
              #:name_last

      #component Services::Components::DriverInformation

      #value :do_not_rent, as: :do_not_rent?
      #value :rentals_count, as: -> (d) { d.rentals.count }


      #collection :randoms, as: Services::Components::Random

      #collection :rentals do |c|
        #object :rental
        #id :number


        #value :number
      #end
    end
  end

  private

  def query
    Driver.includes(:rentals).all
  end
end
