class Services::Admin::User::Locations < Lib::Services::Base

  def initialize(user)
    @user = user
  end

  def fetch
    user.locations.select(:name, :slug)
  end
end
