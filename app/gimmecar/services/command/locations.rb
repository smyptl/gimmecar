class Services::Command::Locations < Lib::Services::Base

  output do
    collection :locations do |c|
      c.attributes :name, :city, :state
    end
  end

  private

  def query
    Location.all
  end
end
