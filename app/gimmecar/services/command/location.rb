class Services::Command::Location < Lib::Services::Base

  attributes do |a|
    a.string :slug
  end

  output do
    object :location do |o|
      o.attributes :name,
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
    Location.find_by(slug: slug)
  end
end
