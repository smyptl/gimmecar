class Services::Command::Locations < Lib::Services::Base

  output do
    collection :locations do |c|
      c.attributes :name,
        :slug,
        :address_1,
        :address_2,
        :city,
        :state,
        :zip_code,
        :phone_number
    end
  end

  private

  def query
    Location.all
  end
end
