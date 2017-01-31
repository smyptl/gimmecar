class Services::Admin::User::Locations < Lib::Services::Base

  def initialize(user)
    @user = user
  end

  def fetch
    user.locations.map do |l|
      {
        :name => l.name,
        :slug => l.slug,
      }
    end
  end
end
