class Admin::LoginController < Admin::BaseController

  before_action :authorize_api, only: :create
  skip_before_action :authenticate_user

  def index
    if current_user
      redirect_to admin_locations_path
    else
      render_layout
    end
  end

  def create
    success = lambda do |args|
      cookies.encrypted[:token] = {
        value:    args.fetch(:token),
        secure:   Rails.env.production?,
        expires:  1.month.from_now,
        httponly: true,
      }

      render json: {}, status: 200
    end

    Actions::Admin::User::Login.new(params).execute(success, failure)
  end

  #def destroy
    #cookies.delete(:token)
  #end
end
