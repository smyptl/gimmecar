class Services::Command::Drivers < Lib::Services::Base

  output do
    collection :drivers do |o| #, logic: Logic::Driver do |o|
      o.attribute :name_full
      o.attribute :do_not_rent, as: :do_not_rent?

      #o.component Services::Builders::Driver

      # o.attribute :rentals_count, output: -> (d) { d.rentals.count }#, if: -> (d) { d.rentals.any? }

      #o.collection :another_name, as: :rentals do |c|
        #c.id :number
        #c.attributes :number,
          #:pickup,
          #:drop_off
      #end
    end
  end


  private

  def query
    ::Driver.all
  end
end
