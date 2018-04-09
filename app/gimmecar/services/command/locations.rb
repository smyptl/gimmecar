class Services::Command::Locations < Lib::Services::Base

  output do
    collection :locations do |c|
      c.attributes :name,
        :slug,
        :phone_number

      c.component Services::Builders::Address
    end
  end

  private

  def query
    Location.all
  end
end
