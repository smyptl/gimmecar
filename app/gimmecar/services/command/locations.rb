class Services::Command::Locations < Lib::Services::Base

  output do
    collection :locations do |c|
      c.attributes :name,
        :slug,
        :phone_number,
        :address_1,
        :address_2,
        :city,
        :state,
        :zip_code
    end
  end

  private

  def query
    ::Location.all
  end
end
