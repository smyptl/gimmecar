class Services::Admin::User::Locations < Lib::Services::Base

  def output
    params.fetch(:user).locations.select(:name, :slug)
  end
end
