class Services::Command::Drivers < Lib::Services::Base

  def initialize
  end

  def fetch
    ::Driver.includes(:rentals).all
  end
end
